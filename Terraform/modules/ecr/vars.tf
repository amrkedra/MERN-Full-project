
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

# Define the number of ECR repositories to create dynamically
variable "repository_count" {
  type    = number

}