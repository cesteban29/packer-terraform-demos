terraform {
  required_providers {
    hcp = {
      source  = "hashicorp/hcp"
      version = "~> 0.54.0"
    }
    
    aws = {
      source = "hashicorp/aws"
      version = "4.30.0"
    }
  }
}

provider "hcp" {}

provider "aws" {
  region = var.region
}

#PACKER ITERATION
data "hcp_packer_iteration" "hashicat" {
  bucket_name = "hashicat-demo"
  channel     = "latest"
}

#PACKER IMAGE
data "hcp_packer_image" "ubuntu_us_east_1" {
  bucket_name    = "hashicat-demo"
  cloud_provider = "aws"
  iteration_id   = data.hcp_packer_iteration.hashicat.ulid
  region         = "us-east-1"
}

module "hashicat" {
  source  = "app.terraform.io/cesteban-tfc/hashicat/aws"
  version = "1.9.1"
  instance_type = "var.instance_type"
  region = var.region
  instance_ami = data.hcp_packer_image.ubuntu_us_east_1.cloud_image_id
}
