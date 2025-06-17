resource "aws_ecr_repository" "app_repo" {
  name = "${var.project_name}-app-repo"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = { Name = "${var.project_name}-app-ecr-repo" }
}

resource "aws_ecs_cluster" "main_cluster" {
  name = "${var.project_name}-cluster"
  tags = { Name = "${var.project_name}-ecs-cluster" }
}

data "aws_iam_policy_document" "ecs_task_execution_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "${var.project_name}-ecs-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy_attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


resource "aws_cloudwatch_log_group" "app_log_group" {
  name = "/ecs/${var.project_name}-app"
  tags = { Name = "${var.project_name}-app-log-group" }
}

resource "aws_ecs_task_definition" "app_task" {
  family = "${var.project_name}-app-task"
  network_mode = "awsvpc"
  requires_compatibilities =   ["FARGATE"]
  cpu = "256"
  memory = "512"
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name = "${var.project_name}-container"
      image = var.image_uri
      essential = true
      portMappings = [
        {
        containerPort = 8080
        hostPort = 8080
      }
      ]

      environment = [
        {name = "DB_HOST", value = var.db_host},
        {name = "DB_PORT", value = var.db_port},
        {name = "DB_USER", value = var.db_user},
        {name = "DB_NAME", value = var.db_name},
        {name = "DB_PASSWORD", value = var.db_password}
      ],
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group" = aws_cloudwatch_log_group.app_log_group.name,
          "awslogs-region" = "${var.aws_region}"
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])

  tags = { Name = "${var.project_name}-app-task-definition" }
}


resource "aws_ecs_service" "app_service" {
  name            = "${var.project_name}-service"
  cluster         = aws_ecs_cluster.main_cluster.id
  task_definition = aws_ecs_task_definition.app_task.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets         = var.private_subnet_ids
    security_groups = [var.app_security_group_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.app_target_group_arn
    container_name   = "${var.project_name}-container"
    container_port   = 8080
  }

  
  depends_on = [
     var.listener_arn,
    aws_cloudwatch_log_group.app_log_group
  ]
}