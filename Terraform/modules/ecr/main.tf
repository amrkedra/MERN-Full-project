resource "aws_ecr_repository" "ecr_repository-1" {
  name                 = var.repository_name
  image_tag_mutability = var.image_tag_mutability
  tags = {
    Environment = var.env[0]
    Project     = "MyProject"
  }
}

# Lifecycle policy for the ECR repository
resource "aws_ecr_lifecycle_policy" "my_ecr_policy" {
  repository = aws_ecr_repository.ecr_repository-1.name

  # Correctly defined lifecycle policy without the trigger
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
