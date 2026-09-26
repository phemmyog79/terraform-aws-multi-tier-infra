variable "project_name" {
  description = "Name prefix applied to all resources."
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC the database is deployed into."
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for the DB subnet group."
  type        = list(string)
}

variable "ecs_security_group_id" {
  description = "Security group ID of the ECS tasks; the only clients allowed to reach the DB."
  type        = string
}

variable "db_name" {
  description = "Name of the initial database created on the instance."
  type        = string
  default     = "appdb"
}

variable "db_username" {
  description = "Master username for the database."
  type        = string
  default     = "appuser"
}

variable "db_instance_class" {
  description = "RDS instance class (db.t3.micro keeps portfolio costs low)."
  type        = string
  default     = "db.t3.micro"
}
