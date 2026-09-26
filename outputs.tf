output "alb_dns_name" {
  description = "Public DNS name of the load balancer. Open http://<this> in a browser."
  value       = module.alb.alb_dns_name
}

output "ecs_cluster_name" {
  description = "Name of the ECS cluster."
  value       = module.ecs.cluster_name
}

output "ecs_service_name" {
  description = "Name of the ECS service."
  value       = module.ecs.service_name
}

output "rds_endpoint" {
  description = "Connection endpoint of the RDS PostgreSQL instance."
  value       = module.rds.db_endpoint
}

output "db_credentials_secret_arn" {
  description = "ARN of the Secrets Manager secret holding the DB credentials."
  value       = module.rds.db_secret_arn
  sensitive   = true
}

output "vpc_id" {
  description = "ID of the created VPC."
  value       = module.vpc.vpc_id
}
