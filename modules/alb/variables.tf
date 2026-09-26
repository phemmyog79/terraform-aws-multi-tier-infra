variable "project_name" {
  description = "Name prefix applied to all resources."
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC the ALB is deployed into."
  type        = string
}

variable "public_subnet_ids" {
  description = "Public subnet IDs for the ALB (at least two, in different AZs)."
  type        = list(string)
}
