# HCP Terraform Module for EC2 Instance

This is a Terraform module that creates an EC2 instance in AWS

## Providers

AWS provider is used to create the EC2 instance.

TFE provider is used to get the VPC and subnet IDs from another workspace.

## Resources

- aws_eip: Creates an Elastic IP address for the EC2 instance.
- tls_private_key: Creates a private key for the EC2 instance.
- aws_key_pair: Creates a key pair for the EC2 instance.
- aws_instance: Creates the EC2 instance.

## Inputs

- tfe_organization: The name of the TFE organization.
- tfe_workspace: The name of the TFE workspace.
- prefix: This prefix will be included in the name of all resources.
- region: The region where this will be deployed.
- instance_type: Specifies the AWS instance type.
- instance_ami: Provide the AMI ID for the instance.

## Outputs

- instance_url: The URL of the EC2 instance.
- instance_ip: The IP address of the EC2 instance.