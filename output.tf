output "db_endpoint" {
  value = aws_db_instance.db.endpoint
}

output "db_username" {
  value = aws_db_instance.db.username
}

output "db_password_ssm" {
  value = aws_ssm_parameter.db_password.name
}

output "db_name" {
  value = aws_db_instance.db.name
}

output "db_id" {
  value = aws_db_instance.db.id
}
