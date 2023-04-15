terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=4.59"
    }
    http = {
      source  = "hashicorp/http"
      version = ">=3.2.1"
    }
  }
  backend "s3" {
    bucket = "remotebackend-terraform"
    key    = "tf-backend/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region  = "us-east-1"
  profile = "vscode-personal"

  default_tags {
    tags = {
      managed_by = "Terraform Managed resource"
      project    = "Self Managed Env"
    }
  }
}

provider "http" {}
