
variable "project_name" {
  description = "Project name to use in tags and resource names"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC."
  type        = string
}

variable "app_port" {
  description = "The port the application will listen on."
  type        = number
  default     = 8080
}

variable "db_port" {
  description = "The port the database will listen on."
  type        = number
  default     = 5432
}