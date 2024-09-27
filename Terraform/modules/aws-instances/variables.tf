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
  type    = number
}

variable "instance_type" {
  type = string
  description = "the default type of instances, if not available choose t3.micro"

}

variable "key_name" {
  type = string
  description = "the key pair for ec2 instances of bahrain"
  sensitive = true
}

variable "env" {
  type    = list(string)
  description = "the working env"
}

variable "names" {
  description = "names of the instances"
  type = string
}

variable "associate_public_ip_address" {
  description = "associate_public_ip_address"
  type = bool
}

variable "cidr_block" {
  type = string
  description = "the IP V4 CIDR for the VPC"
}

variable "aws_Region" {
  type = string
  description = "the region & availability zone"
}

variable "availability_zone" {
  type = string
  description = "availabilty zone in aws"
}

variable "private_key_path" {
  type = string
  description = "private_key_path"
}