variable "project_name" {
  description = "Name prefix applied to all resources."
  type        = string
}

variable "environment" {
  description = "Environment label (e.g. dev, staging, prod)."
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC. Subnets are carved out of it automatically."
  type        = string
  default     = "10.0.0.0/16"
}
