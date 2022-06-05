output "endpoint" {
  value       = aws_db_instance.db.endpoint
  description = "Endpoint of database in `address:port` format"
}

output "address" {
  value       = aws_db_instance.db.address
  description = "The hostname of the RDS instance"
}

output "port" {
  value       = aws_db_instance.db.port
  description = "Port at which RDS database is listening for traffic"
}

output "username" {
  value       = aws_db_instance.db.username
  description = "Master username of database"
}

output "name" {
  value       = aws_db_instance.db.name
  description = "Name of default database created by RDS"
}

output "id" {
  value       = aws_db_instance.db.id
  description = "ID of RDS database instance"
}

output "arn" {
  value       = aws_db_instance.db.arn
  description = "ARN of RDS database instance"
}

output "resource_id" {
  value       = aws_db_instance.db.resource_id
  description = "Resource ID of RDS database instance"
}

output "hosted_zone_id" {
  value       = aws_db_instance.db.hosted_zone_id
  description = "Canonical hosted zone ID of RDS database instance"
}

output "password_ssm_name" {
  value       = var.use_ssm ? join(",", aws_ssm_parameter.db.*.name) : null
  description = "Name of SSM Parameter used for storing database password. **Note:** Available only if `use_ssm` is set to true"
}

output "password_ssm_arn" {
  value       = var.use_ssm ? join(",", aws_ssm_parameter.db.*.arn) : null
  description = "ARN of SSM Parameter used for storing database password. **Note:** Available only if `use_ssm` is set to true"
}

output "password_secretsmanager_arn" {
  value       = var.use_secretsmanager ? join(",", module.db_sm.*.arn) : null
  description = "ARN of Secrets Manager used for storing database password. **Note:** Available only if `use_secretsmanager` is set to true"
}

output "secretsmanager_lambda_name" {
  value       = var.use_secretsmanager && var.secretsmanager_enable_auto_rotation ? join(",", aws_lambda_function.secretsmanager.*.name) : null
  description = "Name of lambda function created to rotate database credentials automatically. **Note:** Available only if `use_secretsmanager` and `secretsmanager_enable_auto_rotation` is set to true"
}

output "secretsmanager_lambda_arn" {
  value       = var.use_secretsmanager && var.secretsmanager_enable_auto_rotation ? join(",", aws_lambda_function.secretsmanager.*.arn) : null
  description = "ARN of lambda function created to rotate database credentials automatically. **Note:** Available only if `use_secretsmanager` and `secretsmanager_enable_auto_rotation` is set to true"
}

output "secretsmanager_lambda_sg_ids" {
  value       = var.use_secretsmanager && var.secretsmanager_enable_auto_rotation ? local.secretsmanager_lambda_sg_ids : null
  description = "ID of security groups attached to the rotator lambda function. **Note:** Available only if `use_secretsmanager` and `secretsmanager_enable_auto_rotation` is set to true"
}

output "secretsmanager_lambda_role_name" {
  value       = var.use_secretsmanager && var.secretsmanager_enable_auto_rotation ? join(",", aws_iam_role.lambda_secretsmanager.*.name) : null
  description = "Name of IAM role attached to the rotator lambda function. **Note:** Available only if `use_secretsmanager` and `secretsmanager_enable_auto_rotation` is set to true"
}

output "secretsmanager_lambda_role_arn" {
  value       = var.use_secretsmanager && var.secretsmanager_enable_auto_rotation ? join(",", aws_iam_role.lambda_secretsmanager.*.arn) : null
  description = "ARN of IAM role attached to the rotator lambda function. **Note:** Available only if `use_secretsmanager` and `secretsmanager_enable_auto_rotation` is set to true"
}
