output "endpoint" {
  value = aws_db_instance.db.endpoint
}

output "address" {
  value = aws_db_instance.db.address
}

output "port" {
  value = aws_db_instance.db.port
}

output "username" {
  value = aws_db_instance.db.username
}

output "password_ssm" {
  value = aws_ssm_parameter.db_password.name
}

output "name" {
  value = aws_db_instance.db.name
}

output "id" {
  value = aws_db_instance.db.id
}

output "arn" {
  value = aws_db_instance.db.arn
}

output "resource_id" {
  value = aws_db_instance.db.resource_id
}

output "hosted_zone_id" {
  value = aws_db_instance.db.hosted_zone_id
}
