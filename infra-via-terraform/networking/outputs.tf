output "public_subnets" {
  value = aws_subnet.devops_public_subnet.*.id
}

output "public_sg" {
  value = aws_security_group.devops_public_sg.id
}

output "public_k8s_sg" {
  value = aws_security_group.devops_k8s_public_sg.id
}

output "subnet_ips" {
  value = aws_subnet.devops_public_subnet.*.cidr_block
}