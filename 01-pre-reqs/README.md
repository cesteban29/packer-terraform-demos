# Pre-requisites for the demos (Modules that need to be added to HCP Terraform Registry)

- [aws-networking](aws-networking/README.md)
- [ec2-module](ec2-module/README.md)

# Create a new repository named 'terraform-aws-aws-networking'

- Copy over the contents of the `aws-networking` folder to the new repository.
- Add the new repository to the HCP Terraform Registry as a module with tag based versioning.

# Create a new repository named 'terraform-aws-ec2-module'

- Copy over the contents of the `ec2-module` folder to the new repository.
- Add the new repository to the HCP Terraform Registry as a module with tag based versioning.
- This module uses the TFE provider to get the VPC and subnet IDs from another workspace by sharing tfe_outputs