output "jenkins_server_id" {
  value = join(", ", aws_instance.jenkins_server.*.id)
}
output "jenkins_server_ip" {
  value = join(", ", aws_instance.jenkins_server.*.public_ip)
}

output "docker_server_id" {
  value = join(", ", aws_instance.docker_server.*.id)
}
output "docker_server_ip" {
  value = join(", ", aws_instance.docker_server.*.public_ip)
}

output "ansible_server_id" {
  value = join(", ", aws_instance.ansible_server.*.id)
}
output "ansible_server_ip" {
  value = join(", ", aws_instance.ansible_server.*.public_ip)
}