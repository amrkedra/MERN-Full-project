# 
# resource "random_pet" "instance-name" {

#   length    = 3
#   prefix    = "ec2"
#   separator = "-"

# }

# resource "random_id" "instance_id" {
#   count       = 3
#   prefix      = "-"
#   byte_length = "1024"

# }



resource "aws_instance" "web-server" {
  ami                         = var.ami
  instance_type               = var.instatnce_type
  key_name                    = var.key_name
  subnet_id                   = var.subnet_id
  associate_public_ip_address = false
  count                       = var.cou_inst
  tags = {
    env  = count.index + 1 <= 3 ? var.env[0] : count.index + 1 <= 6 ? var.env[1] : var.env[2]
    name = "Ubuntu-server- var.env - ${count.index + 1}"
  }
}


# resource "aws_s3_bucket" "bucket-bahrain-1" {
#   bucket = "bucket-bahrain-1"
#   tags = {
#     name   = "bucket-bahrain-1"
#     region = "me-south-1"
#   }

# }

# resource "aws_instance" "Ubuntu-jenkins" {
#   ami                         = var.ami
#   count                       = var.cou_inst
#   instance_type               = var.instatnce_type
#   associate_public_ip_address = true
#   key_name                    = "keypair-bahrain"
#   vpc_security_group_ids      = ["sg-008bf23ce5571e4c5"]
#   tags = {
#     name = count.index < 1 ? var.names[0] : "${var.names[1]}-${count.index}"
#   }
# }


# output "ips_of_instances" {
#   value = aws_instance.Ubuntu-jenkins[*].public_ip
# }

# resource "local_file" "ips_of_instances" {
#   content  = join("\n", aws_instance.Ubuntu-jenkins[*].public_ip)
#   filename = "ips-of-aws-instances"
# }

# resource "aws_instance" "mail-server" {
#   ami = var.ami
#   instance_type = var.instatnce_type
#   key_name = "keypair-bahrain"
#   subnet_id = var.subnet_id
#   count = 2
#   tags = {
#     name= "mail-server-${count.index+1}"
#     tags= "mai-server"
#   }
# }


# resource "aws_load_balancer" "Load_balancer" {

#     ami = var.Load_balancer.ami
#     instance_type = var.Load_balancer.type
# }


# output "ip-of-mail-server" {
#     value = aws_instance.mail-server.private_ip
#     description = "this is the ip of the mail server"
#     sensitive = false
# }

