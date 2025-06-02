output "vpc_id" {
  description = "Main VPC id"
  value       = aws_vpc.main.id
}

output "public_subnet_a_id" {
  description = "Public Subnet A id"
  value       = aws_subnet.public_a.id
}

output "public_subnet_b_id" {
  description = "Public Subnet B id"
  value       = aws_subnet.public_b.id
}

output "private_subnet_a_id" {
  description = "Private Subnet A id"
  value       = aws_subnet.private_a.id
}

output "private_subnet_b_id" {
  description = "Private Subnet B id"
  value       = aws_subnet.private_b.id
}

output "available_zones_used" {
  description = "List of the first two Availability Zones queried and used for the subnets"
  value = [
    data.aws_availability_zones.available.names[0],
    data.aws_availability_zones.available.names[1]
  ]
}

output "internet_gateway_id" {
  description = "Main gateway id"
  value       = aws_internet_gateway.main_igw.id
}

output "public_route_table_id" {
  description = "Public route table id"
  value       = aws_route_table.public_rt.id
}

output "nat_gateway_eip" {
  description = "NAT Gateway Elastic ip id"
  value       = aws_eip.nat_eip.public_ip
}

output "nat_gateway_id" {
  description = "Main NAT Gateway id"
  value       = aws_nat_gateway.main_nat_gw.id
}

output "private_route_table_id" {
  description = "Main private route table id"
  value       = aws_route_table.private_rt.id
}

output "alb_security_group_id" {
  description = "alb security group id"
  value       = aws_security_group.alb_sg.id
}

output "app_security_group_id" {
  description = "App security group id"
  value       = aws_security_group.app_sg.id
}

output "db_security_group_id" {
  description = "db security group id"
  value       = aws_security_group.db_sg.id
}