# AWS Networking resources for Terraform Demo Environment

These are shared resources that will be used by the ec-2 module that is created in the demo environment (hashicat, terramino, etc.)

This should be it's own HCP TF workspace that you have ran a terraform plan and apply on.

# List of Resources:
- VPC
  * Name: `demo-env-vpc-us-east-1`
  * CIDR Block: `10.0.0.0/16`
- Subnet
  * Name: `demo-env-public-subnet`
  * CIDR Block: `10.0.1.0/24`
- Security Group
  * Name: `public-access-security-group`
  * Ingress:
    - SSH: `22/tcp`
    - HTTP: `80/tcp`
    - HTTPS: `443/tcp`
  * Egress:
    - All traffic: `0.0.0.0/0`

  