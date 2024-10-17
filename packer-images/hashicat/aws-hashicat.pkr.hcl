packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

#Variables cannot be updated during runtime
#This variable is used for the ami_name
variable "ami_prefix" {
  type = string
  default = "hashicat-demo"
}

#Locals are useful when you need to format commanly used values
#
locals{
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "amazon-ebs" "ubuntu" {
  ami_name      = "${var.ami_prefix}-${local.timestamp}"
  instance_type = "t2.micro"
  region        = "us-east-1"
  source_ami_filter {
    filters = {
      name                = "amzn2-ami-hvm-*-x86_64-gp2"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["137112412989"] # This is the AWS account ID for Amazon Linux 2024
  }
  ssh_username = "ec2-user"
}

build {
  name = "hashicat-demo-image"

  hcp_packer_registry {
      bucket_name = "hashicat-demo"
      description = <<EOT
  EC2 image with apache web server on it and hashicat app. 
      EOT
      bucket_labels = {
        "os"             = "Ubuntu",
        "app"            = "Hashicat-app",
      }

      build_labels = {
         "build-time"   = timestamp()
      }
    }

  sources = [
    "source.amazon-ebs.ubuntu"
  ]

  provisioner "file" {
  source = "files/deploy_app.sh"
  destination = "/home/ubuntu/"
  }
  
  provisioner "shell" {
    inline =[
        "echo '*** Installing apache2'",
        "sudo apt-get update -y",
        "sudo apt-get install apache2 -y",
        "echo '*** Completed Installing apache2'",
        "sudo mv /home/ubuntu/deploy_app.sh /var/www/html/index.html"
    ]
  }
}
