terraform {
  required_providers {
    hcp = {
      source  = "hashicorp/hcp"
      version = "~> 0.97.0"
    }
    
    aws = {
      source = "hashicorp/aws"
      version = "5.72.1"
    }
  }
}

provider "hcp" {}

provider "aws" {
  region = var.region
}

#PACKER VERSION
# Get the latest version of the Packer build from HCP Packer
data "hcp_packer_version" "hashicat" {
  bucket_name = "hashicat-demo"
  channel_name = "latest"
}

#PACKER ARTIFACT
# Get the AMI ID from the HCP Packer registry
data "hcp_packer_artifact" "hashicat_us_east_1" {
  bucket_name    = "hashicat-demo"
  version_fingerprint = data.hcp_packer_version.hashicat.fingerprint
  platform = "aws"
  region         = "us-east-1"
}

# HCP TERRAFORM MODULE
module "hashicat" {
  source  = "app.terraform.io/CE-Demos/hashicat/aws"
  version = "1.9.1"
  instance_type = "var.instance_type"
  region = var.region 
  instance_ami = data.hcp_packer_artifact.hashicat_us_east_1.external_identifier # AMI ID from HCP Packer registry
}