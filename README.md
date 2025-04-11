# Packer Terraform Demos

Welcome to the **Packer Terraform Demos** repository! 

This repository contains 2 demos showcasing how to use **HCP Packer** and **HCP Terraform** to build and manage infrastructure. 
Each demo is organized into its own subdirectory for clarity and ease of use.

## Packer + Terraform - Integrations Used

- **HCP Packer Run Task** 
	1. Data Source Artifact Validation
		- Scans for use of hcp_packer_version and hcp_packer_artifact data sources.
		- Warns if any referenced artifact version is revoked.
	2. Resource Artifact Validation
		- Scans for hard-coded machine image IDs in Terraform resources.
		- Checks if these images are tracked in HCP Packer.
		- Warns if the image's artifact version is revoked.
		- Promotes best practice by encouraging use of HCP Packer data sources instead of hard-coded IDs.

- **HCP Packer Webhook in AWS**
	- Implements a handler for HCP Packer webhook events for AWS AMIs, using an API Gateway and Lambda function.
	- Currently handles the following HCP Packer events:
		- Completed iteration: adds tags to the AMI(s) with HCP Packer metadata
		- Revoked iteration: deprecates the AMI(s) and adds the revocation reason as a tag
		- Restored iteration: cancels the AMI deprecation and removes the tags added by the revoked handler
		- Deleted iteration: deregisters the AMI(s) and deletes the associated snapshots
	- Credit to Dan Barr for building [`this`](https://github.com/danbarr/hcp-packer-webhook-aws)

- **HCP Packer Data Sources in Terraform**
	- The hcp_packer_artifact and hcp_packer_version data sources allow Terraform to dynamically fetch metadata and AMI IDs from HCP Packer instead of hardcoding AMI IDs.
	- Instead of pasting static AMI IDs into Terraform configs (which get stale or revoked), the data source dynamically pulls the correct, latest AMI from HCP Packer.
	- The data source integrates with HCP Packer's lifecycle metadata:
		- Channel-based sourcing (e.g., get the latest "production" image)
		- Awareness of revoked or outdated versions

- **Continuous Validation checks for Day 2 Guarantees**
    - Automated daily checks of deployed infrastructure against HCP Packer registry
    - Identifies infrastructure running:
        - Revoked images (security vulnerabilities, compliance issues)
        - Outdated images (newer versions available)
        - Deprecated images (end-of-life or unsupported)
    - Provides detailed reporting through HCP Portal:
        - Resource inventory with image status
        - Age of deployed images
        - Version differences between environments
    - Enables proactive risk management:
        - Early warning system for security vulnerabilities
        - Compliance drift detection
        - Technical debt identification
    - Integrates with existing notification systems:
        - Slack/Teams notifications
        - Email alerts
        - Ticket creation in ITSM systems

## 📁 Repository Structure

- [`.github/workflows/`](.github/workflows/README.md) - GitHub Actions workflows for building Packer images.
- [`01-pre-reqs/aws-networking`](./01-pre-reqs/aws-networking/README.md) - AWS Landing Zone.
- [`01-pre-reqs/aws-webhook`](./01-pre-reqs/aws-webhook/README.md) - AWS Webhook for HCP Packer.
- [`01-pre-reqs/ec2-module`](./01-pre-reqs/ec2-module/README.md) - HCP Terraform Module for EC2 Instance.
- [`02-packer-images/hashicat`](./02-packer-images/hashicat/README.md) - HashiCat Packer Images (Dev and Prod).
- [`02-packer-images/terramino`](./02-packer-images/terramino/README.md) - Terramino Packer Images (Dev and Prod).
- [`hashicat-demo/`](./hashicat-demo/README.md) - Terraform deployment for HashiCat (Dev and Prod).
- [`terramino-demo/`](./terramino-demo/README.md) - Terraform deployment for Terramino (Dev and Prod).
---
### 🔑 Credentials & Accounts Required:
- AWS Credentials for your AWS Account
	- add AWS creds to Github Actions workflow for Packer build workflow
	- add AWS creds to HCP Terraform workspaces deploying resources to AWS
- HCP Credentials for your HashiCorp Cloud Platform project
	- add HCP creds to Gtihuc Actions workflow for Packer build workflow
- HCP Terraform account for deploying infrastructure using IaC
---
# 🔄 Workflow

## 1. Store Private Terraform Module into HCP Terraform Organization to be used in Demo

### [ec2-module](#hcp-terraform-modules-created): deploys VM and scaffolding
- This requires creating a seperate repository with proper module naming (ex: terraform-aws-nameofmodule)

## 2. Deploy Pre-Requisite Terraform workspaces

### [`01-pre-reqs/aws-networking`](./01-pre-reqs/aws-networking/README.md) - AWS Landing Zone creating a VPC
### [`01-pre-reqs/aws-webhook`](./01-pre-reqs/aws-webhook/README.md) - AWS Webhook for HCP Packer

## 3. Deploy Demo Terraform Workspaces (Hashicat & Terramino)

### HashiCat
#### [`hashicat-demo/dev`](./hashicat-demo/README.md) - Terraform deployment for HashiCat (Dev)
#### [`hashicat-demo/prod`](./hashicat-demo-README.md) - Terraform deployment for HashiCat (Prod)
### Terramino
#### [`terramino-demo/dev`](./terramino-demo/README.md) - Terraform deployment for Terramino (Dev)
#### [`terramino-demo/prod`](./terramino-demo/README.md) - Terraform deployment for Terramino (Dev)

## 4. Build Packer Images in Github Actions after adding Credentials

#### [`02-packer-images/hashicat`](./02-packer-images/hashicat/README.md) - HashiCat Packer Images (Dev and Prod).
#### [`02-packer-images/terramino`](./02-packer-images/terramino/README.md) - Terramino Packer Images (Dev and Prod).

Use the Github Actions workflows diefined in the [`github/workflows`](./github/workflows/README.md) directory

## 5. Deliver Packer-Terraform Demo Script

### Introduction & Problem Statement
"Let me start by asking - how do you currently manage your machine images across your organization? [Pause for response] Many organizations face challenges with:
- Tracking which images are in use where 
- Managing image updates across environments
- Ensuring compliance and security standards
- Preventing drift between dev and prod environments"

### Solution Overview
"Today I'll show you how HCP Packer and Terraform work together to solve these challenges through:
- Centralized image management
- Automated image lifecycle handling  
- Continuous compliance validation
- Streamlined dev-to-prod workflows"

### Demo Flow

#### A. Image Building & Management (HCP Packer)
"Let's start by building an image using HCP Packer. But first, why Packer?
- **Reproducibility**: Every image build is version-controlled and documented
- **Standardization**: Ensure all teams use approved, consistent base images
- **Automation**: Eliminate manual image creation and reduce human error"

[Demo the image build process]

"Notice how HCP Packer automatically:
- Versions each build
- Tracks metadata
- Provides an audit trail
- Integrates with your existing AWS infrastructure"

#### B. Image Lifecycle Management (Webhook Demo)
"Here's where it gets interesting. What happens when you need to revoke an image due to a security vulnerability?

[Demo the webhook functionality]

When we revoke an image in HCP Packer:
- AWS AMIs are automatically deprecated
- Tags are updated with revocation reasons
- Associated resources are properly managed
- No manual cleanup required, saving operational overhead"

#### C. Infrastructure Deployment (HCP Terraform)
"Now, let's see how this integrates with your infrastructure deployment:

[Deploy hashicat-dev workspace]

Key points to highlight:
1. **Dynamic Image Selection**: No more hardcoded AMI IDs
2. **Run Task Validation**: Automatic checks for revoked or outdated images
3. **Channel-based Deployment**: Easy promotion from dev to prod"

#### D. Day 2 Operations
"This is crucial for ongoing operations. How do you currently identify systems running outdated or vulnerable images?

[Show Continuous Validation]

- Daily automated checks
- Proactive notification of risks
- Clear upgrade paths
- Compliance reporting capabilities"

### Business Impact
"Let's discuss how this translates to business value:
- **Risk Reduction**: Automated compliance and security checks
- **Cost Savings**: Efficient image lifecycle management
- **Time to Market**: Streamlined dev-to-prod pipeline
- **Operational Efficiency**: Reduced manual intervention"

### Interactive Demonstration
[Show either HashiCat or Terramino enhancement scenario]

"Let's make this relevant to your environment. How would this workflow integrate with your current processes? [Pause for discussion]"

### Q&A and Next Steps
"What specific challenges in your image management process would you like to explore further?"

### Demo Tips
- Ask open-ended questions throughout
- Listen for pain points to tailor the demo
- Connect features to specific business outcomes
- Provide concrete examples relevant to their industry
- Keep technical depth flexible based on audience
