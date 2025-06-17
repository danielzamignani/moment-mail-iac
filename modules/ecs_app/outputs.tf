output "ecr_repository_url" {
  description = "The URL of the application's ECR repository."
  value       = aws_ecr_repository.app_repo.repository_url
}

output "ecs_cluster_name" {
  description = "The name of the ECS Cluster."
  value       = aws_ecs_cluster.main_cluster.name
}

# output "ecs_service_name" {
#   description = "The name of the ECS Service."
#   value       = aws_ecs_service.app_service.name
# }