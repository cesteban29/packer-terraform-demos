# MODULE VERSIONS
# variables cannot be used in the module version argument :( sad isn't it?
variable "ec2_module_version" {
  description = "The version of the ec2 module"
  default     = "1.5.0"
}

# MODULE VARIABLES
variable "instance_type" {
  description = "the size of the ec2 instance that you are provisioning!"
}

variable "region" {
  default = "us-east-1"
}

variable "hcp_project_id" {
  description = "The HCP project ID"
  default = "65bd0d48-2dae-452b-9fb6-da5e021a9490"
}

variable "prefix" {
  description = "The prefix for the resources"
  default = "prod-hashicat"
}