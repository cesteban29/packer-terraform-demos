#main.tf

# DYNAMIC PACKER IMAGE RETRIEVAL - GOLDEN IMAGE PIPELINE
# Get the AMI ID from the HCP Packer registry - single artifact sourcing https://registry.terraform.io/providers/hashicorp/hcp/latest/docs/data-sources/packer_artifact#single-artifact-sourcing
data "hcp_packer_artifact" "hashicat-artifact" {
  bucket_name    = "hashicat-demo"
  channel_name = "prod"
  platform = "aws"
  region         = var.region
}

# Deploys dynamically retrieved AMI from HCP Packer registry to AWS EC2
module "hashicat" {
  # EC2 INSTANCE MODULE
  source  = "app.terraform.io/cesteban-tfc/ec2-instance/aws"
  version = "1.5.0"
  instance_type = var.instance_type
  region = var.region 
  prefix = var.prefix
  instance_ami = data.hcp_packer_artifact.hashicat-artifact.external_identifier # AMI ID from HCP Packer registry
}