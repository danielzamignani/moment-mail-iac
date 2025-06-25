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

data "aws_caller_identity" "current" {}

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

module "alb" {
  source = "./modules/alb"

  project_name          = var.project_name
  vpc_id                = module.vpc.vpc_id
  public_subnet_ids     = module.vpc.public_subnet_ids
  alb_security_group_id = module.security_groups.alb_sg_id
}

module "ecs_app" {
  source = "./modules/ecs_app"

  project_name          = var.project_name
  vpc_id                = module.vpc.vpc_id
  private_subnet_ids    = module.vpc.private_subnet_ids
  app_security_group_id = module.security_groups.app_sg_id
  app_target_group_arn  = module.alb.app_target_group_arn
  listener_arn          = module.alb.http_listener_arn # Passando o listener ARN
  aws_region            = var.aws_region

  # Passando as informações do banco de dados do módulo RDS e das variáveis raiz
  image_uri   = var.app_image_uri
  db_host     = module.rds.db_instance_address
  db_port     = tostring(module.rds.db_instance_port)
  db_user     = var.db_username
  db_password = var.db_password
  db_name     = module.rds.db_instance_name
}

module "cicd" {
  source = "./modules/cicd"

  project_name            = var.project_name
  codestar_connection_arn = var.codestar_connection_arn
  ecr_repository_arn      = module.ecs_app.ecr_repository_arn
  ecr_repository_name     = module.ecs_app.ecr_repository_name
  aws_account_id          = data.aws_caller_identity.current.account_id
}