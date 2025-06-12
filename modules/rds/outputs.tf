output "db_instance_address" {
  description = "The address (endpoint) of the RDS database instance."
  value       = aws_db_instance.main.address
  sensitive   = true
}

output "db_instance_port" {
  description = "The port of the RDS database instance."
  value       = aws_db_instance.main.port
}

output "db_instance_name" {
  description = "The DB name created in the RDS instance."
  value       = aws_db_instance.main.db_name
}
