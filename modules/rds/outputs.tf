output "db_endpoint" {
  description = "Connection endpoint of the RDS instance (hostname:port)."
  value       = aws_db_instance.main.endpoint
}

output "db_address" {
  description = "Hostname of the RDS instance."
  value       = aws_db_instance.main.address
}

output "db_port" {
  description = "Port of the RDS instance."
  value       = aws_db_instance.main.port
}

output "db_secret_arn" {
  description = "ARN of the Secrets Manager secret holding the DB credentials."
  value       = aws_secretsmanager_secret.db.arn
  sensitive   = true
}
