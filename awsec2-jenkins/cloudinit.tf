data "template_file" "init-script" {
  template = file("scripts/init.cfg")
  vars = {
    REGION = var.region
  }
}

data "template_file" "shell-script-1" {
  template = file("scripts/sslcert.sh")
}

data "template_file" "shell-script-2" {
  template = file("scripts/nginx.sh")
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
}