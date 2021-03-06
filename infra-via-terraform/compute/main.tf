##COMPUTE

data "aws_ami" "server_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*-x86_64-gp2"]
  }
}

resource "aws_instance" "jenkins_server" {
  count         = 1
  instance_type = var.instance_type
  ami           = data.aws_ami.server_ami.id

  tags = {
    Name = "jenkins_Host"
  }

  key_name               = var.key_name
  vpc_security_group_ids = [var.security_group]
  subnet_id              = var.subnets[count.index]
  user_data              = data.template_cloudinit_config.cloudinit-jenkins.rendered
}

resource "aws_instance" "docker_server" {
  count         = 1
  instance_type = var.instance_type
  ami           = data.aws_ami.server_ami.id

  tags = {
    Name = "Docker_Host"
  }

  key_name               = var.key_name
  vpc_security_group_ids = [var.security_group]
  subnet_id              = var.subnets[count.index]
  user_data              = data.template_cloudinit_config.cloudinit-docker.rendered
}

resource "aws_instance" "ansible_server" {
  count         = 1
  instance_type = var.instance_type
  ami           = data.aws_ami.server_ami.id

  tags = {
    Name = "Ansible_Host"
  }

  key_name               = var.key_name
  vpc_security_group_ids = [var.security_group]
  subnet_id              = var.subnets[count.index]
  user_data              = data.template_cloudinit_config.cloudinit-ansible.rendered
}