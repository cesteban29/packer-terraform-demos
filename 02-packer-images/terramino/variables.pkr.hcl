# Packer Auto Variables

# Packer will automatically load any var file that matches the name *.auto.pkrvars.hcl
# without the need to pass the file via the command line if you do "packer build ."

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "aws_instance_type" {
  type    = string
  default = "t2.micro"
}
