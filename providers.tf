terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=4.59"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "vscode-personal"

  default_tags {
    tags = {
      managed_by = "Terraform Managed resource"
      project    = "Self Managed K8s"
    }
  }
}
