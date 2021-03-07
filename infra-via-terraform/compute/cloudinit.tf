data "template_file" "shell-script-jenkins" {
  template = file("scripts/jenkins.sh")
}

data "template_cloudinit_config" "cloudinit-jenkins" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.shell-script-jenkins.rendered
  }
}


data "template_file" "shell-script-docker" {
  template = file("scripts/docker.sh")
}

data "template_cloudinit_config" "cloudinit-docker" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.shell-script-docker.rendered
  }
}


data "template_file" "shell-script-ansible" {
  template = file("scripts/ansible.sh")
}

data "template_cloudinit_config" "cloudinit-ansible" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.shell-script-ansible.rendered
  }
}


data "template_file" "shell-script-k8s" {
  template = file("scripts/k8s.sh")
}

data "template_cloudinit_config" "cloudinit-k8s" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.shell-script-k8s.rendered
  }
}