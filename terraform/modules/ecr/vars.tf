variable "aws_Region" {
  description = "The AWS region to deploy resources in."
  type        = string
}

variable "repository_name" {
  description = "The name of the ECR repository."
  type        = string

}

variable "env" {
  description = "Environment labels"
  type        = list(string)
}

variable "image_tag_mutability" {
  description = "The tag mutability setting for the ECR repository"
  type        = string

}
