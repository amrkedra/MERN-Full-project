output "eks_cluster_sg_id" {
  value = aws_security_group.eks_cluster_sg.id
}

output "eks_worker_sg_id" {
  value = aws_security_group.eks_worker_sg.id
}

output "jump_server_sg_id" {
  value = aws_security_group.jump_server_sg.id
}
