variable "project_name" {
  description = "Project name to use in tags and resource names"
  type        = string
  default     = "moment-mail"
}

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

variable "public_subnet_cidrs" {
  description = "CIDR blocks for the public subnets."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for the private subnets."
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "db_username" {
  description = "Master username for the RDS database instance."
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Master password for the RDS database instance."
  type        = string
  sensitive   = true
}

variable "app_image_uri" {
  description = "The full URI of the application's Docker image in ECR."
  type        = string
}

variable "codestar_connection_arn" {
  description = "The ARN of the CodeStar Connection to GitHub, created manually in the AWS Console."
  type        = string
}
