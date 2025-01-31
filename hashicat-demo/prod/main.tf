#main.tf

# DYNAMIC PACKER IMAGE RETRIEVAL - GOLDEN IMAGE PIPELINE
# Get the latest version of the Packer build from HCP Packer
data "hcp_packer_version" "hashicat-version" {
  bucket_name = "hashicat-demo"
  channel_name = "prod"
}

# Get the AMI ID from the HCP Packer registry
data "hcp_packer_artifact" "hashicat-artifact" {
  bucket_name    = "hashicat-demo"
  version_fingerprint = data.hcp_packer_version.hashicat-version.fingerprint
  platform = "aws"
  region         = var.region
}

# Deploys dynamically retrieved AMI from HCP Packer registry to AWS EC2
module "hashicat" {
  # EC2 INSTANCE MODULE
  source  = "app.terraform.io/cesteban-tfc/ec2-instance/aws"
  version = var.ec2_module_version
  instance_type = var.instance_type
  region = var.region 
  prefix = var.prefix
  instance_ami = data.hcp_packer_artifact.hashicat-artifact.external_identifier # AMI ID from HCP Packer registry
}