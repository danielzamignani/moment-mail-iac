output "ecr_repository_url" {
  description = "The URL of the application's ECR repository."
  value       = aws_ecr_repository.app_repo.repository_url
}

output "ecr_repository_arn" {
  description = "The ARN of the application's ECR repository."
  value       = aws_ecr_repository.app_repo.arn
}

output "ecr_repository_name" {
  description = "The ARN of the application's ECR repository."
  value       = aws_ecr_repository.app_repo.name
}

output "ecs_cluster_name" {
  description = "The name of the ECS Cluster."
  value       = aws_ecs_cluster.main_cluster.name
}

