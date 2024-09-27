output "ecr_repository_url" {
  description = "The URL of the created ECR repository."
  value       = aws_ecr_repository.ecr_repository-1.repository_url
}
