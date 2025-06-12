variable "project_name" {
  description = "Project name to use in tags and resource names"
  type        = string
}

variable "db_subnet_ids" {
  description = "A list of private subnet IDs for the DB subnet group."
  type        = list(string)
}

variable "db_security_group_ids" {
  description = "A list of security group IDs to associate with the DB instance."
  type        = list(string)
}

variable "db_username" {
  description = "Master username for the RDS instance."
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Master password for the RDS instance."
  type        = string
  sensitive   = true
}

variable "instance_class" {
  description = "The instance class for the RDS instance."
  type        = string
  default     = "db.t3.micro"
}

variable "engine_version" {
  description = "The PostgreSQL engine version."
  type        = string
  default     = "17.4"
}