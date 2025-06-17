variable "project_name" {
  description = "The base name for project resources."
  type        = string
}

variable "aws_region" {
    description = "The base name for project resources."
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC."
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for the Fargate tasks."
  type        = list(string)
}

variable "app_security_group_id" {
  description = "The ID of the security group for the application."
  type        = string
}

variable "app_target_group_arn" {
  description = "The ARN of the ALB's target group for the application."
  type        = string
}

variable "image_uri" {
  description = "The URI of the Docker image in ECR (e.g., ACCOUNT_ID.dkr.ecr.REGION.amazonaws.com/REPO:TAG)."
  type        = string
}

# Variáveis para as credenciais do banco de dados
variable "db_host" {
  description = "Database host endpoint."
  type        = string
  sensitive   = true
}
variable "db_port" {
  description = "Database port."
  type        = string # String para passar como env var
  sensitive   = true
}
variable "db_user" {
  description = "Database username."
  type        = string
  sensitive   = true
}
variable "db_password" {
  description = "Database password."
  type        = string
  sensitive   = true
}
variable "db_name" {
  description = "Database name."
  type        = string
  sensitive   = true
}

variable "listener_arn" {
  description = "Database name."
  type        = string
}