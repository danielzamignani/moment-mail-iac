variable "aws_region" {
  description = "Region where resources will be created"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "project_name" {
  description = "Project name to use in tags and resource names"
  type        = string
  default     = "moment-mail"
}



variable "db_username" {
  description = "Master username for the RDS database instance."
  type        = string
  sensitive   = true
  # Sem default, para ser fornecido via .tfvars ou variável de ambiente
}

variable "db_password" {
  description = "Master password for the RDS database instance."
  type        = string
  sensitive   = true
  # Sem default, para ser fornecido via .tfvars ou variável de ambiente
}
