variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "private_subnet_a_cidr" {
  description = "CIDR block for private subnet A"
  type        = string
}

variable "private_subnet_b_cidr" {
  description = "CIDR block for private subnet B"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR block for public subnet"
  type        = string
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

# Variables for the EKS cluster


variable "private_subnet_ids" {
  description = "List of private subnet IDs for the EKS nodes"
  type        = list(string)
}



variable "vpc_id" {
  description = "The VPC ID for EKS"
  type        = string
}



# VPC Variables
variable "cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "private_subnets" {
  description = "The list of private subnet CIDR blocks"
  type        = list(string)
}
