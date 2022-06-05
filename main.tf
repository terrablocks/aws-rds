data "aws_kms_key" "db" {
  key_id = var.db_kms_key
}

data "aws_kms_key" "db_insights" {
  key_id = var.performance_insights_kms_key
}

resource "random_password" "db" {
  count   = var.random_password == true ? 1 : 0
  length  = 20
  special = false
}

locals {
  db_password = var.random_password == true ? random_password.db.0.result : var.db_password
}

resource "aws_db_subnet_group" "db" {
  count       = var.db_subnet_group_name == "" ? 1 : 0
  name        = var.instance_name
  subnet_ids  = var.db_subnet_ids
  description = "Database subnet group"
}

resource "aws_iam_role" "rds_role" {
  count = var.monitoring_interval > 0 ? 1 : 0
  name  = "${var.instance_name}-detailed-monitoring-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "monitoring.rds.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "rds_role_policy" {
  count      = var.monitoring_interval > 0 ? 1 : 0
  role       = aws_iam_role.rds_role.0.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

data "aws_db_subnet_group" "db" {
  count = length(var.db_sg_ids) == 0 ? 1 : 0
  name  = var.db_subnet_group_name == "" ? join(",", aws_db_subnet_group.db.*.name) : var.db_subnet_group_name
}

data "aws_vpc" "db" {
  count = length(var.db_sg_ids) == 0 ? 1 : 0
  id    = join(",", data.aws_db_subnet_group.db.*.vpc_id)
}

resource "aws_security_group" "db" {
  count       = length(var.db_sg_ids) == 0 ? 1 : 0
  name        = "${var.instance_name}-sg"
  description = "Security group for ${var.instance_name} database"
  vpc_id      = join(",", data.aws_db_subnet_group.db.*.vpc_id)

  ingress {
    from_port   = var.db_port
    to_port     = var.db_port
    protocol    = "tcp"
    cidr_blocks = data.aws_vpc.db.0.cidr_block_associations.*.cidr_block
    description = "Allow connections only from within the VPC"
  }
}

locals {
  db_sg_ids = length(var.db_sg_ids) == 0 ? aws_security_group.db.*.id : var.db_sg_ids
}

resource "aws_db_instance" "db" {
  # checkov:skip=CKV_AWS_157: Multi-AZ deployment is user dependant feature
  # checkov:skip=CKV_AWS_129: Enabling logs depends on user
  # checkov:skip=CKV_AWS_118: Enhanced monitoring is user dependant feature
  # checkov:skip=CKV_AWS_16: Enabling SSE depends on user
  engine             = var.engine
  engine_version     = var.engine_version
  identifier         = var.instance_name
  username           = var.db_username
  password           = local.db_password
  instance_class     = var.instance_type
  ca_cert_identifier = var.ca_cert

  storage_type          = var.storage_type
  allocated_storage     = var.storage_size
  iops                  = var.storage_type == "io1" ? var.iops : null
  max_allocated_storage = var.max_allocated_storage
  storage_encrypted     = var.storage_encrypted
  kms_key_id            = var.storage_encrypted == true ? data.aws_kms_key.db.arn : null

  multi_az               = var.multi_az
  db_subnet_group_name   = var.db_subnet_group_name == "" ? aws_db_subnet_group.db.0.id : var.db_subnet_group_name
  publicly_accessible    = var.publicly_accessible
  vpc_security_group_ids = local.db_sg_ids
  port                   = var.db_port

  db_name              = var.db_name == "" || length(regexall("oracle-*", var.engine)) > 0 || length(regexall("sqlserver-*", var.engine)) > 0 ? null : var.db_name
  parameter_group_name = var.parameter_group_name
  option_group_name    = var.option_group_name

  backup_retention_period = var.backup_retention_period
  backup_window           = var.backup_window
  copy_tags_to_snapshot   = var.copy_tags_to_snapshot

  monitoring_interval = var.monitoring_interval
  monitoring_role_arn = var.monitoring_interval > 0 ? aws_iam_role.rds_role.0.arn : null

  enabled_cloudwatch_logs_exports = var.cw_log_exports

  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_kms_key_id       = var.performance_insights_enabled == true ? data.aws_kms_key.db_insights.arn : null
  performance_insights_retention_period = var.performance_insights_enabled == true ? var.performance_insights_retention_period : null

  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  maintenance_window         = var.maintenance_window

  skip_final_snapshot       = var.skip_final_snapshot
  final_snapshot_identifier = var.final_snapshot_identifier
  deletion_protection       = var.deletion_protection

  iam_database_authentication_enabled = var.enable_iam_auth

  # specific to oracle
  character_set_name = length(regexall("oracle-*", var.engine)) > 0 ? var.character_set : null
  license_model      = length(regexall("oracle-*", var.engine)) > 0 ? var.db_license : null

  # specific to ms-sql
  domain   = var.ad_domain_id
  timezone = var.timezone

  # to restore from a snapshot
  snapshot_identifier = var.snapshot_id

  allow_major_version_upgrade = var.allow_major_version_upgrade
  apply_immediately           = var.apply_immediately

  tags = var.tags
}

# SSM resources
data "aws_kms_key" "ssm" {
  count  = var.use_ssm ? 1 : 0
  key_id = var.ssm_kms_key
}

resource "aws_ssm_parameter" "db" {
  count  = var.use_ssm ? 1 : 0
  name   = "/rds/${var.instance_name}/password"
  value  = local.db_password
  type   = "SecureString"
  key_id = join(",", data.aws_kms_key.ssm.*.id)
}

# Secretmanager resources
locals {
  db_credentials = {
    engine   = aws_db_instance.db.engine
    host     = aws_db_instance.db.address
    username = aws_db_instance.db.username
    password = local.db_password
    dbname   = aws_db_instance.db.name
    port     = aws_db_instance.db.port
  }
}

module "db_sm" {
  source = "github.com/terrablocks/aws-secretsmanager.git?ref=v1.0.0"

  count             = var.use_secretsmanager ? 1 : 0
  name              = "/rds/${var.instance_name}"
  description       = "Store credentials for ${var.instance_name} database"
  kms_key           = var.secretsmanager_kms_key
  delete_after_days = var.secretsmanager_delete_after_days
  secret_string     = jsonencode(local.db_credentials)
  lambda_arn        = var.secretsmanager_enable_auto_rotation ? join(",", aws_lambda_function.secretsmanager.*.arn) : null
  rotate_after_days = var.secretsmanager_enable_auto_rotation ? var.secretsmanager_rotate_after_days : null
  tags              = var.tags
}

resource "aws_iam_role" "lambda_secretsmanager" {
  count                 = var.use_secretsmanager && var.secretsmanager_enable_auto_rotation ? 1 : 0
  name                  = "${var.instance_name}-secretsmanager"
  force_detach_policies = true
  assume_role_policy    = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": [
          "lambda.amazonaws.com"
        ]
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

data "aws_iam_policy_document" "lambda_secretsmanager" {
  # checkov:skip=CKV_AWS_111: Constraint not required
  count = var.use_secretsmanager && var.secretsmanager_enable_auto_rotation ? 1 : 0
  statement {
    actions = [
      "secretsmanager:DescribeSecret",
      "secretsmanager:GetSecretValue",
      "secretsmanager:PutSecretValue",
      "secretsmanager:UpdateSecretVersionStage"
    ]
    resources = module.db_sm.*.arn
  }
  statement {
    actions = [
      "secretsmanager:GetRandomPassword"
    ]
    resources = [
      "*"
    ]
  }
}

resource "aws_iam_role_policy" "lambda_secretsmanager" {
  count  = var.use_secretsmanager && var.secretsmanager_enable_auto_rotation ? 1 : 0
  name   = "${var.instance_name}-secretsmanager"
  role   = join(",", aws_iam_role.lambda_secretsmanager.*.name)
  policy = join(",", data.aws_iam_policy_document.lambda_secretsmanager.*.json)
}

resource "aws_iam_role_policy_attachment" "lambda_secretsmanager_basic" {
  count      = var.use_secretsmanager && var.secretsmanager_enable_auto_rotation ? 1 : 0
  role       = join(",", aws_iam_role.lambda_secretsmanager.*.name)
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

data "aws_subnet" "lambda" {
  count = var.use_secretsmanager && var.secretsmanager_enable_auto_rotation && length(var.secretsmanager_lambda_sg_ids) == 0 ? 1 : 0
  id    = var.secretsmanager_lambda_subnet_ids[0]
}

resource "aws_security_group" "lambda_secretsmanager" {
  count       = var.use_secretsmanager && var.secretsmanager_enable_auto_rotation && length(var.secretsmanager_lambda_sg_ids) == 0 ? 1 : 0
  name        = "${var.instance_name}-secretsmanager-sg"
  description = "Security group for ${var.instance_name}-secretsmanager lambda function"
  vpc_id      = join(",", data.aws_subnet.lambda.*.vpc_id)

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS traffic to anywhere"
  }
}

locals {
  secretsmanager_lambda_sg_ids = var.use_secretsmanager && var.secretsmanager_enable_auto_rotation && length(var.secretsmanager_lambda_sg_ids) == 0 ? aws_security_group.lambda_secretsmanager.*.id : var.secretsmanager_lambda_sg_ids
}

data "aws_s3_object" "secretsmanager" {
  count  = var.use_secretsmanager && var.secretsmanager_enable_auto_rotation ? 1 : 0
  bucket = "terrablocks-secretsmanager-lambda"
  key    = "${split("-", var.engine)[0]}.zip"
}

resource "aws_lambda_function" "secretsmanager" {
  # checkov:skip=CKV_AWS_116: DLQ not required
  count                          = var.use_secretsmanager && var.secretsmanager_enable_auto_rotation ? 1 : 0
  function_name                  = "${var.instance_name}-secretsmanager"
  description                    = "Responsible for rotating credentials for ${var.instance_name} db instance"
  role                           = join(",", aws_iam_role.lambda_secretsmanager.*.arn)
  s3_bucket                      = join(",", data.aws_s3_object.secretsmanager.*.bucket)
  s3_key                         = join(",", data.aws_s3_object.secretsmanager.*.key)
  s3_object_version              = join(",", data.aws_s3_object.secretsmanager.*.version_id)
  handler                        = "lambda_function.lambda_handler"
  runtime                        = "python3.9"
  memory_size                    = 128
  timeout                        = 5
  reserved_concurrent_executions = -1

  tracing_config {
    mode = var.secretsmanager_lambda_tracing_mode
  }

  vpc_config {
    subnet_ids         = var.secretsmanager_lambda_subnet_ids
    security_group_ids = local.secretsmanager_lambda_sg_ids
  }

  tags = var.tags
}

resource "aws_lambda_permission" "secretsmanager" {
  count         = var.use_secretsmanager && var.secretsmanager_enable_auto_rotation ? 1 : 0
  statement_id  = "AllowExecutionFromSecretsManager"
  action        = "lambda:InvokeFunction"
  function_name = join(",", aws_lambda_function.secretsmanager.*.function_name)
  principal     = "secretsmanager.amazonaws.com"
  source_arn    = join(",", module.db_sm.*.arn)
}
