# HashiCat TFC Demo
 *Demo that deploys AWS EC2 instance using a module from the PMR*

# Table of Contents

- [Initial Set-Up](#initial-set-up)
  - [1. Clone Repo's](#clone-repos)
  - [2. Release module in PMR and update code](#release-and-update)
  - [3. Set up Creds](#add-creds)
  - [4. Build Packer Image](#build-image)
  - [5. Deploy with TFC](#set-up-complete)
  - [6. EXTRAS](#extras)


## Initial Set-Up
<a name="initial-set-up"></a>

## Clone Repo's
<a name="clone-repos"></a>

### Clone this Repo
```
git clone https://github.com/cesteban29/hashicat-tfc-demo.git
```

### Clone HashiCat module repository and store in TFC Private Module Registry
This repository consumes that module so it needs to be configured in your Private Module Registry beforehand!

#### 1. Clone HashiCat Module Repo
```
git clone https://github.com/cesteban29/terraform-aws-hashicat.git
```

#### 2. Release a version of the module using a tag in the repo
<a name="release-and-update"></a>
The Terraform Registry uses tags to detect releases.

Tag names must be a valid semantic version, optionally prefixed with a v. Example of valid tags are: v1.0.1 and 0.9.4. To publish a new module, you must already have at least one tag created.

To release a new version, create and push a new tag with the proper format. The webhook will notify the registry of the new version and it will appear on the registry usually in less than a minute.

### Update module block in main.tf to match the module you created in your TFC org
Make sure that the source is pointing to your module in the PMR.
Make sure that the version is set to the tag that you release in your module repo.
[Module Code](https://github.com/cesteban29/tfcb-demo/blob/main/main.tf#L35-L41)

### Add HCP creds and AWS creds to your TFC workspace that this repo is connected to
<a name="add-creds"></a>
I would recommend using Variable Sets for these, but you can use [Dynamic Credentials for AWS](https://developer.hashicorp.com/terraform/cloud-docs/workspaces/dynamic-provider-credentials/aws-configuration)

#### HCP Creds
[Useful HCP Packer Learn Guide](https://developer.hashicorp.com/packer/tutorials/hcp-get-started/hcp-push-image-metadata#create-hcp-service-principal-and-set-to-environment-variable)

In HCP Packer, go to Access control (IAM) in the left navigation menu, then select the Service principals tab.

Create a service principal named packer with the Contributor role.

Once you create the service principal, click the service principal name to view its details. From the detail page, click + Generate key to create a client ID and secret.

Copy and save the client ID and secret; you will not be able to retrieve the secret later.

#### AWS Creds
Sign in to the AWS Management Console.

Open the IAM (Identity and Access Management) service.

In the left navigation pane, click on "Users" or "IAM users" depending on the version of the IAM console.

Locate the IAM user for which you want to generate the credentials and click on its name.

In the "Security credentials" tab, you will find the section called "Access keys".

If there are no access keys present, click on "Create access key" and follow the instructions. This will generate a new access key pair for the user.

After creating the access keys, you will see the access key ID and the corresponding secret access key.

Once you have the access key ID and secret access key, you can use them as environment variables or in your Terraform configuration files

### Build Packer Image
<a name="build-image"></a>

#### HCP Packer Environment Variables
The following environment variables let you configure Packer to push image metadata to an active registry without changing your template. You can use environment variables with both JSON and HCL2 templates. Refer to Basic Configuration With Environment Variables in the HCP Packer documentation for complete instructions and examples.

You must set the following environment variables to enable Packer to push metadata to a registry.

HCP_CLIENT_ID - The HCP client ID of a HashiCorp Cloud Platform service principle that Packer can use to authenticate to an HCP Packer registry.

HCP_CLIENT_SECRET - The HCP client secret of the HashiCorp Cloud Platform service principle that Packer can use to authenticate to an HCP Packer registry.

#### Change deploy_app.sh
Change the HTML to say "Welcome to YOUR_NAME's Cat App"

#### Build image
Run the command:
```
packer build aws-hashicat.pkr.hcl
```

### Configure TF Variable on TFC - Run on TFC
<a name="set-up-complete"></a>

Set a TF variable in your TFC workspace for the ec2 instance type
```
instance_type = t2.micro //This is the value I use to pass Sentinel budget policy
```
```
instance_type = c5d.2xlarge //This is the value I use to fail the Sentinel budget policy to showcase the policy check feature and how soft mandatory policies can be overriden if necessary
```
Deploy this configuration that consumes the hashicat module that you stored in the PMR

## EXTRAS
<a name="extras"></a>

### Sentinel Policy Set 
#### Clone Sentinel Policies Repo
```
git clone https://github.com/cesteban29/hashicat-tfc-sentinel-policies.git
```

### Connect Policy Set to TFC
1. Sign in to your Terraform Cloud account.

2. Open the organization where you want to connect the policy set.

3. In the organization's settings, navigate to the "Policy Sets" section.

4. Click on the "Connect a New Policy Set" button.

5. Configure the policy set by providing the required details:

    Name: Enter a name for the policy set.
    VCS Provider: Choose the version control system provider (e.g., GitHub, GitLab, Bitbucket) where your policy repository is hosted.
    Repository: Select the repository where your policy configuration is stored.
    Policies Path: /Demo
    Set Policies enforced on selected workspaces and then select your demo workspace

6. Click on the "Connect Policy Set" button to connect the policy set to Terraform Cloud.
