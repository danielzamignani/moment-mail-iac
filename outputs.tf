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
  description = "ID do Internet Gateway principal"
  value       = aws_internet_gateway.main_igw.id
}

output "public_route_table_id" {
  description = "ID da Tabela de Rotas Pública principal"
  value       = aws_route_table.public_rt.id
}