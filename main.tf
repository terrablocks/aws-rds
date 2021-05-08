data "aws_kms_key" "ssm_kms_key" {
  key_id = var.ssm_kms_key
}

data "aws_kms_key" "db_kms_key" {
  key_id = var.db_kms_key
}

data "aws_kms_key" "insights_kms_key" {
  key_id = var.performance_insights_kms_key
}

resource "random_password" "db_password" {
  count   = var.random_password == true ? 1 : 0
  length  = 20
  special = false
}

resource "aws_ssm_parameter" "db_password" {
  name   = "/rds/${var.instance_name}/password"
  value  = var.random_password == true ? random_password.db_password.0.result : var.db_password
  type   = "SecureString"
  key_id = var.ssm_kms_key
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
  password           = aws_ssm_parameter.db_password.value
  instance_class     = var.instance_type
  ca_cert_identifier = var.ca_cert

  storage_type          = var.storage_type
  allocated_storage     = var.storage_size
  iops                  = var.storage_type == "io1" ? var.iops : null
  max_allocated_storage = var.max_allocated_storage
  storage_encrypted     = var.storage_encrypted
  kms_key_id            = var.storage_encrypted == true ? data.aws_kms_key.db_kms_key.arn : null

  multi_az               = var.multi_az
  db_subnet_group_name   = var.subnet_group_name == "" ? aws_db_subnet_group.db_subnet_group.0.id : var.subnet_group_name
  publicly_accessible    = var.publicly_accessible
  vpc_security_group_ids = var.sg_ids
  port                   = var.db_port

  name                 = var.db_name == "" || length(regexall("oracle-*", var.engine)) > 0 || length(regexall("sqlserver-*", var.engine)) > 0 ? null : var.db_name
  parameter_group_name = var.parameter_group_name
  option_group_name    = var.option_group_name

  backup_retention_period = var.backup_retention_period
  backup_window           = var.backup_window == "" ? null : var.backup_window
  copy_tags_to_snapshot   = var.copy_tags_to_snapshot

  monitoring_interval = var.monitoring_interval
  monitoring_role_arn = var.monitoring_interval > 0 ? aws_iam_role.rds_role.0.arn : null

  enabled_cloudwatch_logs_exports = var.cw_log_exports

  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_kms_key_id       = var.performance_insights_enabled == true ? data.aws_kms_key.insights_kms_key.arn : null
  performance_insights_retention_period = var.performance_insights_enabled == true ? var.performance_insights_retention_period : null

  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  maintenance_window         = var.maintenance_window == "" ? null : var.maintenance_window

  skip_final_snapshot       = var.skip_final_snapshot
  final_snapshot_identifier = var.final_snapshot_identifier
  deletion_protection       = var.deletion_protection

  iam_database_authentication_enabled = var.enable_iam_auth

  # specific to oracle
  character_set_name = length(regexall("oracle-*", var.engine)) > 0 ? var.character_set : null
  license_model      = length(regexall("oracle-*", var.engine)) > 0 ? var.db_license : null

  # specific to ms-sql
  domain   = length(regexall("sqlserver-*", var.engine)) > 0 ? var.ad_domain_id : null
  timezone = length(regexall("sqlserver-*", var.engine)) > 0 ? var.timezone : null

  # to restore from a snapshot
  snapshot_identifier = var.snapshot_id == "" ? null : var.snapshot_id

  allow_major_version_upgrade = var.allow_major_version_upgrade
  apply_immediately           = var.apply_immediately

  tags = var.tags
}

resource "aws_db_subnet_group" "db_subnet_group" {
  count       = var.subnet_group_name == "" ? 1 : 0
  name        = var.instance_name
  subnet_ids  = var.subnet_ids
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
