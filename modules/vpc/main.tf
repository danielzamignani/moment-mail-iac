resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name      = "${var.project_name}-vpc"
    Project   = var.project_name
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "public" {
for_each = { for i, cidr in var.public_subnet_cidrs : i => cidr }

  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value
  availability_zone       = data.aws_availability_zones.available.names[each.key]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-subnet-${substr(data.aws_availability_zones.available.names[each.key], -1, 1)}"
    Project   = var.project_name
  }
}

resource "aws_subnet" "private" {
  for_each = { for i, cidr in var.private_subnet_cidrs : i => cidr }

  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value
  availability_zone = data.aws_availability_zones.available.names[each.key]

  tags = {
    Name = "${var.project_name}-private-subnet-${substr(data.aws_availability_zones.available.names[each.key], -1, 1)}"
  }
}

resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name      = "${var.project_name}-igw"
    Project   = var.project_name
  }
}

resource "aws_eip" "nat_eip" {
  tags = {
    Name      = "${var.project_name}-nat-gw-eip"
    Project   = var.project_name
  }
}

resource "aws_nat_gateway" "main_nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = values(aws_subnet.public)[0].id

  depends_on = [aws_internet_gateway.main_igw]

  tags = {
    Name      = "${var.project_name}-nat-gateway"
    Project   = var.project_name
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }

  tags = {
    Name      = "${var.project_name}-public-route-table"
    Project   = var.project_name
  }
}

resource "aws_route_table_association" "public_assoc" {
    for_each       = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main_nat_gw.id
  }

  tags = {
    Name      = "${var.project_name}-private-route-table"
    Project   = var.project_name
  }
}

resource "aws_route_table_association" "private_assoc" {
  for_each       = aws_subnet.private
  
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_rt.id
}