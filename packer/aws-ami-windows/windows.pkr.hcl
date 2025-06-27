packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.1"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "region" {
  type    = string
  default = "eu-west-1"
}

locals {
  timestamp      = regex_replace(timestamp(), "[- TZ:]", "")
  winrm_password = var.winrm_password
  winrm_username = var.winrm_username
}


# source blocks are generated from your builders; a source can be referenced in
# build blocks. A build block runs provisioner and post-processors on a
# source.
source "amazon-ebs" "windows" {
  ami_name      = "windows-2022-English-Full-${local.timestamp}"
  communicator  = "winrm"
  instance_type = "t2.medium"
  region        = "${var.region}"
  source_ami_filter {
    filters = {
      name                = "Windows_Server-2022-English-Full-Base*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["amazon"]
  }
  user_data = templatefile("${path.root}/bootstrap_win.pkrtpl.hcl", { winrm_username = local.winrm_username, winrm_password = local.winrm_password })
  # The problem is user_data_file expects a path to a file
  subnet_id                   = "${var.subnet_id}"
  security_group_id           = "${var.security_group_id}"
  associate_public_ip_address = true
  winrm_password              = "${var.winrm_password}"
  winrm_username              = "${var.winrm_username}"
  skip_create_ami             = var.skip_ami
  launch_block_device_mappings {
    device_name           = "/dev/sda1"
    volume_size           = 50
    volume_type           = "gp3"
    delete_on_termination = true
  }

  launch_block_device_mappings {
    device_name           = "/dev/sdb"
    volume_size           = 150
    volume_type           = "gp3"
    delete_on_termination = true
  }
}

# a build block invokes sources and runs provisioning steps on them.
build {
  name    = "dpw-packer"
  sources = ["source.amazon-ebs.windows"]

  provisioner "windows-restart" {
  }

  provisioner "powershell" {
    script = "./installRequiredSoftware.ps1"
    environment_vars = [
      "PASSWORD=${var.winrm_password}"
    ]
  }
  provisioner "powershell" {
    inline = [
      # list all drives
      "Get-PSDrive -PSProvider FileSystem | Format-Table -AutoSize",
      # list all volumes
      "Get-Volume | Format-Table -AutoSize",
      # list all disks
      "Get-Disk | Format-Table -AutoSize",
    ]
  }
}