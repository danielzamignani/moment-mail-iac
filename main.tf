terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws",
      version = "~> 4.16"
    }
  }

  backend "s3" {
    bucket         = "moment-mail-tfstate"
    key            = "moment-mail/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "moment-mail-terraform-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name      = "${var.project_name}-vpc"
    Project   = var.project_name
    ManagedBy = "Terraform"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "public_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]

  map_public_ip_on_launch = true

  tags = {
    Name      = "${var.project_name}-public-subnet-a"
    Project   = var.project_name
    ManagedBy = "Terraform"
    Tier      = "Public"
  }
}

# --- Publlic Subnets ---

resource "aws_subnet" "public_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]

  map_public_ip_on_launch = true

  tags = {
    Name      = "${var.project_name}-public-subnet-b"
    Project   = var.project_name
    ManagedBy = "Terraform"
    Tier      = "Public"
  }
}

# --- Private Subnets ---

resource "aws_subnet" "private_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = false

  tags = {
    Name      = "${var.project_name}-private-subnet-a"
    Project   = var.project_name
    ManagedBy = "Terraform"
    Tier      = "Private"
  }
}

resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]

  map_public_ip_on_launch = false

  tags = {
    Name      = "${var.project_name}-private-subnet-b"
    Project   = var.project_name
    ManagedBy = "Terraform"
    Tier      = "Private"
  }
}

resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name      = "${var.project_name}-igw"
    Project   = var.project_name
    ManagedBy = "Terraform"
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
    ManagedBy = "Terraform"
    Tier      = "Private"
  }
}

resource "aws_route_table_association" "public_a_assoc" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_b_assoc" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_eip" "nat_eip" {
  tags = {
    Name      = "${var.project_name}-nat-gw-eip"
    Project   = var.project_name
    ManagedBy = "Terraform"
  }
}

resource "aws_nat_gateway" "main_nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_a.id

  tags = {
    Name      = "${var.project_name}-nat-gateway"
    Project   = var.project_name
    ManagedBy = "Terraform"
  }

  depends_on = [aws_internet_gateway.main_igw]
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
    ManagedBy = "Terraform"
    Tier      = "Private"
  }
}

resource "aws_route_table_association" "private_a_assoc" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_b_assoc" {
  subnet_id      = aws_subnet.private_b.id
  route_table_id = aws_route_table.private_rt.id
}

