output "jump_server_ip" {
  value = aws_instance.jump_server.public_ip  // Get the public IP of the jump server instance
  description = "The public IP address of the jump server"
}

output "jump_server_private_ip" {
  value = aws_instance.jump_server.private_ip  // Get the private IP of the jump server instance
  description = "The private IP address of the jump server"
}

output "jump_server_id" {
  description = "The ID of the Jump Server"
  value       = aws_instance.jump_server.id
}

output "jenkins_server_id" {
  description = "The ID of the Jenkins Server"
  value       = aws_instance.jenkins_server.id
}