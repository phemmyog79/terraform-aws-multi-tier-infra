variable "aws_region" {
  description = "AWS region to deploy into."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Name prefix applied to all resources. Use lowercase letters and hyphens."
  type        = string
  default     = "devops-portfolio"
}

variable "environment" {
  description = "Environment label (e.g. dev, staging, prod)."
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "container_image" {
  description = "Public container image run by the ECS service."
  type        = string
  default     = "nginx:latest"
}

variable "desired_count" {
  description = "Number of ECS Fargate tasks to run."
  type        = number
  default     = 2
}

variable "db_name" {
  description = "Name of the initial database created on the RDS instance."
  type        = string
  default     = "appdb"
}

variable "db_username" {
  description = "Master username for the RDS instance."
  type        = string
  default     = "appuser"
}

variable "db_instance_class" {
  description = "RDS instance class."
  type        = string
  default     = "db.t3.micro"
}

variable "alert_email" {
  description = "Email address subscribed to CloudWatch alarm notifications. Leave empty to skip."
  type        = string
  default     = ""
}
