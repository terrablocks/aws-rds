output "db_endpoint" {
  value = aws_db_instance.db.endpoint
}

output "db_username" {
  value = aws_db_instance.db.username
}

output "db_name" {
  value = aws_db_instance.db.name
}
