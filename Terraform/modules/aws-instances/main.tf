
resource "aws_vpc" "my-vpc" {
  cidr_block = var.cidr_block
}

resource "aws_subnet" "my-subnet" {
  vpc_id     = aws_vpc.my-vpc.id
  cidr_block = var.cidr_block
  availability_zone = var.availability_zone
  map_public_ip_on_launch = true
  tags = {
    Name = "my-subnet"
  }
}

resource "aws_internet_gateway" "my-internet-gateway" {
  vpc_id = aws_vpc.my-vpc.id

  tags = {
    Name = "my-internet-gateway"
  }
}

resource "aws_route_table" "my-route-table" {
  vpc_id = aws_vpc.my-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-internet-gateway.id
   
  }
  tags = {
    Name = "my-route-table"
  }
}
resource "aws_route_table_association" "rta1" {
  subnet_id      = aws_subnet.my-subnet.id
  route_table_id = aws_route_table.my-route-table.id
}

resource "aws_security_group" "my-security-group" {
  name        = "my-security-group"
  description = "my-security-group for terraform project"
  vpc_id      = aws_vpc.my-vpc.id

  tags = {
    Name = "my-vpc"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.my-security-group.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.my-security-group.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}

resource "aws_vpc_security_group_egress_rule" "egress" {
  security_group_id = aws_security_group.my-security-group.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 0
  ip_protocol = "tcp"
  to_port     = 0
}

resource "aws_security_group_rule" "allow_all_outbound_tcp" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.my-security-group.id
}

resource "aws_instance" "flask-app-server" {
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = aws_subnet.my-subnet.id
  vpc_security_group_ids      = [aws_security_group.my-security-group.id]
  monitoring = true

  connection {
    host        = self.public_ip
    type        = "ssh"
    user        = "ec2-user"
    private_key = file(var.private_key_path)
  }

  #count = var.instance_count

  tags = {
    #Environment = var.env[count.index % length(var.env)]
    #Name        = "${var.names}-${var.env[count.index % length(var.env)]}-${count.index + 1}"
    Name = "flask app server"
    # Add more tags as needed
  }


provisioner "file" {
  source      = "app.py"  # Replace with the path to your local file
  destination = "/home/ec2-user/app.py"  # Replace with the path on the remote instance
}

provisioner "remote-exec" {
  inline = [
    "echo 'Hello from the remote instance'",
    "sudo yum update -y",  # Update package lists (for ubuntu)
    "sudo yum install -y python3-pip",  # Example package installation
    "cd /home/ubuntu",
    "sudo pip3 install flask",
    "sudo python3 app.py &",
  ]
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

