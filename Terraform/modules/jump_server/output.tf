output "jump_server_private_ip" {
  description = "The private IP address of the jump server"
  value       = aws_instance.jump_server.private_ip   # Assuming your jump server instance is named jump_server
}


