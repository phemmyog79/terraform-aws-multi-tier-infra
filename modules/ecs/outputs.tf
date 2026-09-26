output "cluster_name" {
  description = "Name of the ECS cluster."
  value       = aws_ecs_cluster.main.name
}

output "service_name" {
  description = "Name of the ECS service."
  value       = aws_ecs_service.app.name
}

output "log_group_name" {
  description = "CloudWatch log group collecting container logs."
  value       = aws_cloudwatch_log_group.app.name
}

output "ecs_security_group_id" {
  description = "Security group ID of the ECS tasks (used to allow DB access)."
  value       = aws_security_group.ecs.id
}
