terraform {
  backend "s3" {
    bucket         = "bucket-bahrain-2"
    key            = "terraform/terraform.tfstate"
    region         = "me-south-1"
    encrypt        = true
    dynamodb_table = "terraform-state-locking-table"
  }
}

# terraform {
#   backend "local" {
#     path = "terraform.tfstate"

#   }
# }