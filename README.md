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

## 1. Store Private Terraform Module
Store module in HCP Terraform Organization for demo use
### [ec2-module](#hcp-terraform-modules-created)
- Create separate repository with proper module naming (ex: terraform-aws-nameofmodule)
- Deploys VM and scaffolding

## 2. Deploy Pre-Requisite Terraform Workspaces
### [`01-pre-reqs/aws-networking`](./01-pre-reqs/aws-networking/README.md)
AWS Landing Zone creating a VPC
### [`01-pre-reqs/aws-webhook`](./01-pre-reqs/aws-webhook/README.md)
AWS Webhook for HCP Packer

## 3. Deploy Demo Terraform Workspaces
### HashiCat
- [`hashicat-demo/dev`](./hashicat-demo/README.md) - Dev deployment
- [`hashicat-demo/prod`](./hashicat-demo-README.md) - Prod deployment
### Terramino  
- [`terramino-demo/dev`](./terramino-demo/README.md) - Dev deployment
- [`terramino-demo/prod`](./terramino-demo/README.md) - Prod deployment

## 4. Build Packer Images
Add credentials and use Github Actions workflows in [`github/workflows`](./github/workflows/README.md)
- [`02-packer-images/hashicat`](./02-packer-images/hashicat/README.md) - HashiCat images
- [`02-packer-images/terramino`](./02-packer-images/terramino/README.md) - Terramino images

## 5. Demo Script

### Introduction & Problem Statement
"How do you currently manage machine images across your organization? [Pause] Common challenges:
- Tracking image usage
- Managing updates across environments 
- Ensuring compliance and security
- Preventing environment drift"

### Solution Overview
"HCP Packer and Terraform solve these through:
- Centralized image management
- Automated lifecycle handling
- Continuous compliance validation 
- Streamlined dev-to-prod workflows"

### Demo Flow

#### A. Image Building & Management
"Why Packer?
- **Reproducibility**: Version-controlled, documented builds
- **Standardization**: Approved, consistent base images
- **Automation**: Eliminate manual creation and errors

HCP Packer provides:
- Automatic versioning
- Metadata tracking
- Audit trail
- AWS integration"

#### B. Image Lifecycle Management 
"Handling security vulnerabilities:
- Automatic AMI deprecation
- Tag updates with revocation reasons
- Proper resource management
- Zero manual cleanup"

#### C. Infrastructure Deployment
"Integration demo highlights:
1. **Dynamic Image Selection**
2. **Run Task Validation** 
3. **Channel-based Deployment**"

#### D. Day 2 Operations
"Ongoing management features:
- Daily automated checks
- Proactive notifications
- Clear upgrade paths
- Compliance reporting"

### Business Impact
"Value delivered:
- **Risk Reduction**: Automated compliance/security
- **Cost Savings**: Efficient lifecycle management
- **Time to Market**: Streamlined pipeline
- **Operational Efficiency**: Reduced manual work"

### Interactive Demonstration
[HashiCat/Terramino enhancement demo]
"How would this fit your processes?"

### Q&A and Next Steps
"What image management challenges should we explore?"

### Demo Tips
- Ask open questions
- Listen for pain points
- Connect to business outcomes
- Use relevant examples
- Adjust technical depth for audience
