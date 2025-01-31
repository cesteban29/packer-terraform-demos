#main.tf

# DYNAMIC PACKER IMAGE RETRIEVAL - GOLDEN IMAGE PIPELINE
# Get the latest version of the Packer build from HCP Packer
data "hcp_packer_version" "terramino-version" {
  bucket_name  = "terramino-demo"
  channel_name = "prod"
}

# Get the AMI ID from the HCP Packer registry
data "hcp_packer_artifact" "terramino-artifact" {
  bucket_name         = "terramino-demo"
  version_fingerprint = data.hcp_packer_version.terramino-version.fingerprint
  platform            = "aws"
  region              = var.region
}

# Deploys dynamically retrieved AMI from HCP Packer registry to AWS EC2
module "terramino" {
  # EC2 INSTANCE MODULE
  source        = "app.terraform.io/cesteban-tfc/ec2-instance/aws"
  version       = var.ec2_module_version
  instance_type = var.instance_type
  region        = var.region
  prefix        = var.prefix
  instance_ami  = data.hcp_packer_artifact.terramino-artifact.external_identifier # AMI ID from HCP Packer registry
}