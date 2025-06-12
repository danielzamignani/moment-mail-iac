output "vpc_id" {
  description = "The ID of the VPC."
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "List of IDs of public subnets."
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "List of IDs of private subnets."
  value       = module.vpc.private_subnet_ids
}

output "alb_sg_id" {
  description = "The ID of the ALB's security group."
  value       = module.security_groups.alb_sg_id
}

output "app_sg_id" {
  description = "The ID of the Application's security group."
  value       = module.security_groups.app_sg_id
}

output "db_sg_id" {
  description = "The ID of the Database's security group."
  value       = module.security_groups.app_sg_id
}

output "db_instance_address" {
  description = "The address (endpoint) of the RDS database instance."
  value       = module.rds.db_instance_address
  sensitive   = true
}

output "db_instance_port" {
  description = "The port of the RDS database instance."
  value       = module.rds.db_instance_port
}

output "db_instance_name" {
  description = "The DB name created in the RDS instance."
  value       = module.rds.db_instance_name
}
