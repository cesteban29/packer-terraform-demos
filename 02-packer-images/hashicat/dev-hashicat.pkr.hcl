# DEV-HASHICAT Packer Build File

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
  default = "dev-hashicat-demo"
}

variable "aws_instance_type" {
  type = string
  default = "t2.micro"
}

variable "aws_region" {
  type = string
  default = "us-east-1"
}

#Locals are useful when you need to format commanly used values
#
locals{
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "amazon-ebs" "amazon-linux" {
  ami_name      = "${var.ami_prefix}-${local.timestamp}"
  instance_type = var.aws_instance_type // t2.micro
  region        = var.aws_region // us-east-1
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
        "os"             = "Amazon Linux 2024",
        "app"            = "Hashicat-app",
      }

      build_labels = {
         "build-time"   = timestamp()
         "environment"  = "dev"
      }
    }

  sources = [
    "source.amazon-ebs.amazon-linux"
  ]

  provisioner "file" {
  source = "files/dev_hashicat.html"
  destination = "/home/ec2-user/dev_hashicat.html"
  }
  
  provisioner "shell" {
    inline =[
      "echo '*** Installing Apache (httpd)'",
      "sudo yum update -y",
      "sudo yum install httpd -y",
      "echo '*** Completed Installing Apache (httpd)'",
      "sudo mv /home/ec2-user/dev_hashicat.html /var/www/html/index.html",
      "sudo systemctl enable httpd",
      "sudo systemctl start httpd"
    ]
  }
}
