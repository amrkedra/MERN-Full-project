

resource "aws_ecr_repository" "ecr_repository-1" {
  name                 = var.repository_name # Reference the variable directly without quotes
  image_tag_mutability = var.image_tag_mutability
  tags = {
    Environment = var.env[0]
    Project     = "MyProject"
  }
}


# Optionally, add a lifecycle policy to the ECR repository
resource "aws_ecr_lifecycle_policy" "my_ecr_policy" {
  repository = aws_ecr_repository.ecr_repository-1.name  # Use .name to get the repository name
  policy     = jsonencode({
    rules = [
      {
        rulePriority = 1
        selection    = {
          tagStatus = "any"
        }
        action       = {
          type = "expire"
        }
        trigger      = {
          daysSinceImagePushed = 30
        }
      }
    ]
  })
}
