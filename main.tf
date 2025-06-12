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

module "vpc" {
  source = "./modules/vpc"

  project_name         = var.project_name
  vpc_cidr_block       = var.vpc_cidr_block
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}


module "security_groups" {
  source = "./modules/security_groups"

  project_name = var.project_name
  vpc_id       = module.vpc.vpc_id
}

module "rds" {
  source = "./modules/rds"

  project_name          = var.project_name
  db_subnet_ids         = module.vpc.private_subnet_ids
  db_security_group_ids = [module.security_groups.db_sg_id]
  db_username           = var.db_username
  db_password           = var.db_password
}