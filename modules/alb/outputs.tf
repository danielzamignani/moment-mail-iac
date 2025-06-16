output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer."
  value       = aws_lb.main.dns_name
}

output "app_target_group_arn" {
  description = "The ARN of the application's target group."
  value       = aws_lb_target_group.app_tg.arn
}

output "http_listener_arn" {
  description = "The ARN of the HTTP listener."
  value       = aws_lb_listener.http_listener.arn
}
