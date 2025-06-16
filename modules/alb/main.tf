resource "aws_lb" "main" {
    name = "${var.project_name}-alb"
    internal = false
    load_balancer_type = "application"
    security_groups = [var.alb_security_group_id]
    subnets = var.public_subnet_ids

    tags = {
        Name = "${var.project_name}-alb"
        Project = var.project_name
    }
}

resource "aws_lb_target_group" "app_tg" {
    name = "${var.project_name}-alb"
    port = 8080
    protocol = "HTTP"
    vpc_id = var.vpc_id
    target_type = "ip"

    health_check {
      enabled = true
      path = "/health"
      protocol = "HTTP"
      matcher = "200"
      interval = 30
      timeout = 5
      healthy_threshold = 2
      unhealthy_threshold = 2
    }

        tags = {
        Name = "${var.project_name}-app-tg"
        Project = var.project_name
    }
}

resource "aws_lb_listener" "http_listener" {
    load_balancer_arn = aws_lb.main.arn
    port = "80"
    protocol = "HTTP"

    default_action {
      type = "forward"
      target_group_arn = aws_lb_target_group.app_tg.arn
    }

            tags = {
        Name = "${var.project_name}-http-listener"
        Project = var.project_name
    }
}