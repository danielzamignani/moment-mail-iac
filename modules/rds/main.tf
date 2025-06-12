resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = var.db_subnet_ids

  tags = {
    Name      = "${var.project_name}-db-subnet-group"
    Project   = var.project_name
  }
}

resource "aws_db_instance" "main" {
  identifier        = "${var.project_name}-db-instance"
  allocated_storage = 20
  engine            = "postgres"
  engine_version    = var.engine_version
  instance_class    = var.instance_class

  db_name  = "momentmaildb"
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = var.db_security_group_ids

  skip_final_snapshot     = true
  publicly_accessible     = false
  multi_az                = false
  backup_retention_period = 0

  tags = {
    Name      = "${var.project_name}-db-instance"
    Project   = var.project_name
    ManagedBy = "Terraform"
  }
}