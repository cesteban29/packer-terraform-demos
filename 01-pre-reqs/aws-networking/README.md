# AWS Networking resources for Terraform Demo Environment

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