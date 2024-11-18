# use data source tfe_outputs to get vpc id from other workspace using tfe provider
data "tfe_outputs" "aws-networking-outputs" {
  organization = var.tfe_organization
  workspace    = var.tfe_workspace
}


resource "aws_eip" "eip" {
  # An EIP (Elastic IP) is a static IP address that can be associated with an AWS instance. 
  # Associating the EIP with the domain "vpc" ensures that the EIP is allocated for use within a VPC (Virtual Private Cloud), 
  # allowing it to be associated with instances that are part of that VPC.
  instance = aws_instance.compute_instance.id # This is the instance that we want to associate the EIP with
  domain   = "vpc" 
  tags = {
    Name = "${var.prefix}-demo-eip"
  }
}

resource "tls_private_key" "private_key" {
  # This is the private key that we want to generate for the key pair
  algorithm = "RSA"
}

resource "aws_key_pair" "key_pair" {
  # This is the key pair that we want to create for the instance
  key_name   = "${var.prefix}-demo-key-pair"
  public_key = tls_private_key.private_key.public_key_openssh
}

resource "aws_instance" "compute_instance" {
  # This is the instance that we want to create running HashiCat
  ami                         = var.instance_ami
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.key_pair.key_name
  associate_public_ip_address = true
  subnet_id                   = data.tfe_outputs.aws-networking-outputs.values.demo_env_subnet_id
  vpc_security_group_ids      = [data.tfe_outputs.aws-networking-outputs.values.demo_env_security_group_id]

  tags = {
    Name = "${var.prefix}-demo-instance"
  }
}