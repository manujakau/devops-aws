data "template_file" "init-script" {
  template = file("scripts/init.cfg")
  vars = {
    REGION = var.region
  }
}

data "template_file" "shell-script-1" {
  template = file("scripts/java.sh")
}

data "template_file" "shell-script-2" {
  template = file("scripts/jenkins.sh")
}

data "template_file" "shell-script-3" {
  template = file("scripts/maven.sh")
}

data "template_file" "shell-script-4" {
  template = file("scripts/path.sh")
}

data "template_cloudinit_config" "cloudinit-example" {
  gzip          = false
  base64_encode = false

  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = data.template_file.init-script.rendered
  }

  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.shell-script-1.rendered
  }

  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.shell-script-2.rendered
  }

  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.shell-script-3.rendered
  }

  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.shell-script-4.rendered
  }

}