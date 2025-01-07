##############################################################################
# Variables File
#
# Here is where we store the default values for all the variables used in our
# Terraform code. If you create a variable with no default, the user will be
# prompted to enter it (or define it via config file or command line flags.)

variable "tfe_organization" {
  description = "The name of the TFE organization."
  default = "?"
}

variable "tfe_workspace" {
  description = "The name of the TFE workspace."
  default = "?"
}

variable "prefix" {
  description = "This prefix will be included in the name of all resources"
}

variable "region" {
  description = "the region where this will be deployed"
  default = "us-east-1"
}

variable "instance_type" {
  description = "Specifies the AWS instance type."
  default = "t3.micro"
}

variable "instance_ami"{
  description = "Provide the AMI ID for the instance"
}