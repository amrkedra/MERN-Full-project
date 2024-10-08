variable "ami" {
  type        = string
  description = "the ami name"
  nullable    = false
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


variable "associate_public_ip_address" {
  description = "associate_public_ip_address"
  type = bool
}



variable "region" {
  type = string
  description = "the region & availability zone"
}

variable "availability_zones" {
  type = list(string)
  description = "availabilty zone in aws"
}

variable "private_key_path" {
  type = string
  description = "private_key_path"
}

variable "vpc_id" {

  description = "the VPC ID"
  type = string
  
}

variable "vpc_cidr" {
  description = "the vpc cidr"
  type = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}
