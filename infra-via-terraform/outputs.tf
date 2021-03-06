output "Public_Subnets" {
  value = join(", ", module.networking.public_subnets)
}

output "Subnet_IPs" {
  value = join(", ", module.networking.subnet_ips)
}

output "Public_Security_Group" {
  value = module.networking.public_sg
}

output "Jenkins_Instance_IDs" {
  value = module.compute.jenkins_server_id
}
output "Jenkins_Instance_IPs" {
  value = module.compute.jenkins_server_ip
}

output "docker_Instance_IDs" {
  value = module.compute.docker_server_id
}
output "docker_Instance_IPs" {
  value = module.compute.docker_server_ip
}

output "ansible_Instance_IDs" {
  value = module.compute.ansible_server_id
}
output "ansible_Instance_IPs" {
  value = module.compute.ansible_server_ip
}