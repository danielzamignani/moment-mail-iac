variable "project_name" {
  description = "Project name to use in tags and resource names"
  type        = string
}

variable "codestar_connection_arn" {
  description = "The ARN of the CodeStar Connection to GitHub."
  type        = string
}

variable "ecr_repository_arn" {
  description = "The ARN of the application's ECR repository."
  type        = string
}

variable "ecr_repository_name" {
  description = "The ARN of the application's ECR repository."
  type        = string
}

variable "aws_account_id" {
  description = "The AWS Account ID where resources are being deployed."
  type        = string
}