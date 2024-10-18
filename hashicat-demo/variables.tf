
variable "instance_type" {
  description = "the size of the ec2 instance that you are provisioning!"
}

variable "region" {
  default = "us-east-1"
}

variable "hcp_project_id" {
  description = "The HCP project ID"
  default = "cesteban-project"
}

variable "prefix" {
  description = "The prefix for the resources"
  default = "dev"
}