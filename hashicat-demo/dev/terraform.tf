terraform {
  required_providers {
    hcp = {
      source  = "hashicorp/hcp"
      version = "~> 0.97.0"
    }
    
    aws = {
      source = "hashicorp/aws"
      version = "5.72.1"
    }
  }
}

provider "hcp" {
  project_id = var.hcp_project_id
}

provider "aws" {
  region = var.region
}