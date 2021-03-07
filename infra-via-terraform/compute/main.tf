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

data "aws_ami" "server_ami2" {
  most_recent = true
  owners      = ["099720109477"] #Canonical

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
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

resource "aws_instance" "k8s_server" {
  count                = 1
  instance_type        = var.instance_type_kube
  ami                  = data.aws_ami.server_ami2.id
  iam_instance_profile = aws_iam_instance_profile.k8s_profile.name

  tags = {
    Name = "K8s_Host"
  }

  key_name               = var.key_name
  vpc_security_group_ids = [var.security_group_kube]
  subnet_id              = var.subnets[count.index]
  user_data              = data.template_cloudinit_config.cloudinit-k8s.rendered
}