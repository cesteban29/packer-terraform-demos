 # Packer Terraform Demos

Welcome to the **Packer Terraform Demos** repository! This repository contains a collection of demos showcasing how to use **HCP Packer** and **HCP Terraform** to build and manage infrastructure. Each demo is organized into its own subdirectory for clarity and ease of use.

## 📁 Repository Structure

- [`hashicat-demo/`](#hashicat-demo) - A demo deploying the HashiCat application using Terraform.
- [`docker-server-demo/`](#docker-server-demo) - (Coming Soon) A demo deploying a Docker server using Terraform.
- [`packer-images/`](#packer-images) - Contains Packer build configurations for creating custom machine images.

---

## 🚀 Getting Started

These demos are designed to help you understand how Packer and Terraform can work together to automate the building of machine images and the provisioning of infrastructure.


## Prerequisites

- [Packer](https://www.packer.io/downloads) installed on your local machine.
- [Terraform](https://www.terraform.io/downloads) installed on your local machine.
- [HashiCorp Cloud Platform (HCP) Packer](https://cloud.hashicorp.com/products/packer)
- An AWS account with appropriate permissions (Doormat preferred)

---

## 📦 Demos

### HashiCat Demo

The **HashiCat Demo** demonstrates how to deploy the HashiCat application using Terraform.

HashiCat is a simple web application that displays a cat picture.

**Location:** [`hashicat-demo/`](hashicat-demo/)

### Terramino Demo

The **Terramino Demo** demonstrates how to deploy the Terramino application using Terraform + Packer.

Terramino is a tetris game with HashiCorp product colors.

**Location:** [`terramino-demo/`](terramino-demo/)

#### Contents

- **Terraform Configuration Files**: Scripts to provision AWS infrastructure for the HashiCat application.
- **Instructions**: Step-by-step guide to deploy the application.

#### Usage

1. Navigate to the `hashicat-demo` directory:

   ```bash
   cd hashicat-demo
   ```

2. Initialize Terraform:

   ```bash
   terraform init
   ```

3. Review the Terraform plan:

   ```bash
   terraform plan
   ```

4. Apply the Terraform configuration:

   ```bash
   terraform apply
   ```

5. Follow any additional instructions provided in the `hashicat-demo` directory.

### Docker Server Demo

**Status:** *Coming Soon*

The **Docker Server Demo** will showcase how to deploy a Docker server using Terraform.

**Location:** [`docker-server-demo/`](docker-server-demo/)

#### Contents

- **Terraform Configuration Files**: Scripts to provision AWS infrastructure for a Docker server.
- **Instructions**: Step-by-step guide to deploy the Docker server.

#### Usage

Instructions will be added once the demo is available.

---

## 🛠️ Packer Images

The `packer-images` directory contains Packer build configurations used to create custom machine images.

**Location:** [`packer-images/`](packer-images/)

### Structure

- `packer-images/hashicat/`: Packer template for building image used in the HashiCat demo.
- `packer-images/dockerserver/`: (Coming Soon) Packer templates for building images for the Docker server demo.
- `packer-images/minecraftserver/`: (Coming Soon) Additional Packer templates for other demos.

### Building Images with Packer

You can build the custom machine images locally using Packer or leverage **GitHub Actions** workflows provided in this repository to automate the process.

#### Building Locally

1. Navigate to the desired Packer image directory:

   ```bash
   cd packer-images/hashicat
   ```

2. Initialize Packer:

   ```bash
   packer init .
   ```

3. Validate the Packer template:

   ```bash
   packer validate your-template.pkr.hcl
   ```

4. Build the image:

   ```bash
   packer build your-template.pkr.hcl
   ```

   **Note:** Replace `your-template.pkr.hcl` with the actual filename of the Packer template you wish to build.

#### Building with GitHub Actions

This repository includes GitHub Actions workflows that automatically build the Packer images when changes are pushed to the repository.

- **Location of Workflows:** `.github/workflows/`

- **Trigger Conditions:**

  - The workflow triggers when changes are made to the Packer template files in the `packer-images/` directory.

- **Benefits:**

  - **Automation:** No need to build images manually.
  - **Continuous Integration:** Ensures that your images are up-to-date with the latest changes.
  - **Consistency:** Builds are executed in a controlled environment, reducing discrepancies.

##### Usage

1. **Ensure GitHub Actions is Enabled:**

   - GitHub Actions must be enabled for your repository. This is typically the default setting.

2. **Set Up Required Secrets:**

   - Navigate to your repository settings and add the following secrets under **Settings > Secrets and variables > Actions**:

     - `AWS_ACCESS_KEY_ID`
     - `AWS_SECRET_ACCESS_KEY`
     - `HCP_CLIENT_ID` (if using HCP Packer)
     - `HCP_CLIENT_SECRET` (if using HCP Packer)

3. **Push Changes to the Repository:**

   - When you push changes to the Packer templates under `packer-images/`, the GitHub Actions workflow will automatically start and build the images.

4. **Monitor Workflow Runs:**

   - Go to the **Actions** tab in your repository to monitor the progress of the workflows.
   - You can view logs and details of each step.

5. **Access Built Images:**

   - Upon successful completion, the images will be available in your configured image repository (e.g., AWS AMIs).

---

## 🌐 Prerequisites Setup

Configure Credentials:

   For Packer Builds:
   - AWS CLI
   - HCP Packer

   For Terraform:
   - HCP Platform for HCP Packer
   - AWS Credentials

HCP Terraform Setup:
   - Have a HCP TF organization
   - Have a HCP TF workspace


