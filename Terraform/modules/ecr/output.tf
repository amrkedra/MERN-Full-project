output "ecr_repository_urls" {
  description = "The URLs of the created ECR repositories."
  value       = [for repo in aws_ecr_repository.ecr_repos : repo.repository_url]
}
