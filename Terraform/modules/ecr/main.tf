

# Define repository names (they will be created as ecr_repo-1, ecr_repo-2, etc.)
resource "aws_ecr_repository" "ecr_repos" {
  count                = var.repository_count
  name                 = "ecr-repo-${count.index + 1}"  # Creates ecr_repo-1, ecr_repo-2, etc.
  image_tag_mutability = var.image_tag_mutability
  tags = {
    Environment = var.env[0]
    Project     = "MyProject"
  }
}

# Lifecycle policy for each ECR repository
resource "aws_ecr_lifecycle_policy" "my_ecr_policy" {
  count      = var.repository_count
  repository = aws_ecr_repository.ecr_repos[count.index].name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        selection = {
          tagStatus = "any"
          countType = "sinceImagePushed"
          countUnit = "days"
          countNumber = 30
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}
