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

provider "hcp" {
  project_id = var.hcp_project_id
}

provider "aws" {
  region = var.region
}

#PACKER VERSION
# Get the latest version of the Packer build from HCP Packer
data "hcp_packer_version" "hashicat" {
  bucket_name = "hashicat-demo"
  channel_name = "dev"
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
  source  = "app.terraform.io/cesteban-tfc/hashicat/aws"
  version = "1.9.3"
  instance_type = var.instance_type
  region = var.region 
  prefix = var.prefix
  instance_ami = data.hcp_packer_artifact.hashicat_us_east_1.external_identifier # AMI ID from HCP Packer registry
}