# Packer Terraform Demos

Welcome to the **Packer Terraform Demos** repository! 

This repository contains a collection of demos showcasing how to use **HCP Packer** and **HCP Terraform** to build and manage infrastructure. 
Each demo is organized into its own subdirectory for clarity and ease of use.

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
# 🔄 Workflow
1. Create Module ([ec2-module](#hcp-terraform-modules-created)) and add to HCP TF Registry
2. Create Workspaces ([6 of them](#hcp-terraform-workspaces-created)) via VCS Integration
	a. aws-demo-environment
	b. aws-webhook-hcp-packer
	c. hashicat-dev
	d. hashicat-prod
	e. terramino-dev
	f. terramino-prod
3. Build Images (4 of them) via Github Actions
	a. dev-hashicat
	b. prod-hashicat
	c. dev-terramino
	d. prod-terramino
4. Set images to buckets in HCP Packer (4 of them)
5. Deploy workspaces in HCP Terraform
6. Deliver Demo!

---
# 🛠️ Pre-Requisites 

### 🔑 Credentials Required:
- AWS Credentials
- HCP Credentials
- HCP Terraform Account
---

### 🧩 HCP Terraform Modules Created:
**This requires moving code into a seperate repository and following appropriate naming convention**
- ec2-instance
- aws-networking (optional)
---

### 🏗️ HCP Terraform Workspaces Created:
**Make sure that all workspaces have their appropriate working directory defined in the workspace settings**

- aws-demo-environment
	- uses the 01-pre-reqs/aws-networking folder
- aws-webhook-hcp-packer
	- uses the 01-pre-reqs/aws-webhook
- hashicat-dev
	- uses hashicat-demo/dev
- hashicat-prod
	- uses hashicat-demo/prod
- terramino-dev
	- uses terramino-demo/dev
- terramino-prod
	- uses terramino-demo/dev



