terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.4"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
    hcp = {
      source  = "hashicorp/hcp"
      version = "~> 0.82"
    }
  }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Application = "HCP Packer"
      Automation  = "terraform"
      Environment = var.environment
      Owner       = var.owner
      HCPOrg      = data.hcp_organization.current.name
      HCPProject  = data.hcp_project.current.name
    }
  }
}

provider "hcp" {}
