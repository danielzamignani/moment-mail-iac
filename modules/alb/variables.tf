variable "project_name" {
  description = "The base name for project resources."
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC where the ALB will be deployed."
  type        = string
}

variable "public_subnet_ids" {
  description = "A list of public subnet IDs to attach the ALB to."
  type        = list(string)
}

variable "alb_security_group_id" {
  description = "The ID of the security group to associate with the ALB."
  type        = string
}