

variable "azure_client_id" {
  description = "azure username"
  type        = string
  sensitive   = false
}

variable "azure_client_secret" {
  type        = string
  description = "azure password"
  sensitive   = true
}

variable "azure_subscription_id" {
  type        = string
  description = "azure subscription id"
  sensitive   = false
}

variable "azure_tenant_id" {
  type        = string
  description = "azure tenant id"
  sensitive   = false
}

variable "azure_region" {
  type        = string
  description = "region of azure resource"
}

# variable "aws_access_key" {
#   type = string
#   description = "aws access key"
#   sensitive = true
# }

# variable "aws_secret_key" {
#   type = string
#   description = "aws_secret_key"
#   sensitive = true
# }

variable "aws_Region" {
  type        = string
  description = "aws_Region"
}

variable "ami" {
  type        = string
  description = "the ami name"
  nullable    = false
}

variable "subnet_id" {
  type        = string
  description = "the default subnet id for aws-bahrain region"
}

variable "instance_count" {
  type = number
}

variable "instance_type" {
  type        = string
  description = "the default type of instances, if not available choose t3.micro"

}

variable "key_name" {
  type        = string
  description = "key-for-terraform"
  sensitive   = true
}

variable "env" {
  type        = list(string)
  description = "the working env"
}

variable "associate_public_ip_address" {
  type        = bool
  description = "associate_public_ip_address"
}

variable "names" {
  description = "names of the instances"
  type        = string
}

variable "cidr_block" {
  type        = string
  description = "the IP V4 CIDR for the VPC"
}

variable "availability_zone" {
  type        = string
  description = "availabilty zone in aws"
}

variable "private_key_path" {
  type        = string
  description = "private_key_path"
}



variable "repository_name" {
  description = "The name of the ECR repository."
  type        = string

}


variable "image_tag_mutability" {
  description = "The tag mutability setting for the ECR repository"
  type        = string

}


variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "private_subnet_a_cidr" {
  description = "CIDR block for private subnet A"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_b_cidr" {
  description = "CIDR block for private subnet B"
  type        = string
  default     = "10.0.2.0/24"
}

variable "public_subnet_cidr" {
  description = "CIDR block for public subnet"
  type        = string
  default     = "10.0.3.0/24"
}

variable "availability_zone_a" {
  description = "Availability zone for private subnet A"
  type        = string
}

variable "availability_zone_b" {
  description = "Availability zone for private subnet B"
  type        = string
}

variable "availability_zone_c" {
  description = "Availability zone for public subnet"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the security groups will be created"
  type        = string
}

variable "cluster_cidr_blocks" {
  description = "CIDR blocks allowed for EKS cluster"
  type        = list(string)
}

variable "worker_cidr_blocks" {
  description = "CIDR blocks allowed for EKS worker nodes"
  type        = list(string)
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_role_arn" {
  description = "ARN of the IAM role for the EKS cluster"
  type        = string
}

variable "node_role_arn" {
  description = "ARN of the IAM role for the EKS nodes"
  type        = string
}

variable "node_group_name" {
  description = "Name of the EKS node group"
  type        = string
}

variable "desired_size" {
  description = "Desired size of the EKS node group"
  type        = number
}

variable "max_size" {
  description = "Maximum size of the EKS node group"
  type        = number
}

variable "min_size" {
  description = "Minimum size of the EKS node group"
  type        = number
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for the EKS nodes"
  type        = list(string)
}
