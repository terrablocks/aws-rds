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

output "password_ssm_name" {
  value       = aws_ssm_parameter.db_password.name
  description = "Name of SSM Parameter used for storing database password"
}

output "password_ssm_arn" {
  value       = aws_ssm_parameter.db_password.arn
  description = "ARN of SSM Parameter used for storing database password"
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
