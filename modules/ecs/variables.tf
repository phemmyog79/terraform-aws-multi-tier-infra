variable "project_name" {
  description = "Name prefix applied to all resources."
  type        = string
}

variable "aws_region" {
  description = "AWS region, used for the CloudWatch Logs configuration."
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC the ECS resources are deployed into."
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for the Fargate tasks."
  type        = list(string)
}

variable "alb_security_group_id" {
  description = "Security group ID of the ALB; tasks only accept traffic from it."
  type        = string
}

variable "target_group_arn" {
  description = "ARN of the ALB target group the service registers with."
  type        = string
}

variable "container_image" {
  description = "Public container image to run (e.g. nginx:latest)."
  type        = string
  default     = "nginx:latest"
}

variable "task_cpu" {
  description = "CPU units for the Fargate task (256 = 0.25 vCPU)."
  type        = string
  default     = "256"
}

variable "task_memory" {
  description = "Memory (MiB) for the Fargate task."
  type        = string
  default     = "512"
}

variable "desired_count" {
  description = "Number of Fargate tasks to run."
  type        = number
  default     = 2
}

variable "log_retention_days" {
  description = "CloudWatch Logs retention for container logs, in days."
  type        = number
  default     = 7
}
