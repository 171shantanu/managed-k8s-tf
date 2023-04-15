# Declaring locals
locals {
  name_suffix = "${var.environment}-${var.project}"
}

# declaring the aws module
module "aws" {
  source = "./aws"
}

# declaring the aws/instances module
module "instances" {
  source = "./aws/instances"
}

# declaring the aws/rds module
module "rds" {
  source = "./aws/rds"

  db_username = var.db_username
  db_password = var.db_password
}

# declaring the aws/iam module
module "iam" {
  source = "./aws/iam"
}

# declaring the aws/s3 module
module "s3" {
  source = "./aws/s3"
}

# variable for project
variable "project" {
  type        = string
  description = "Project Name"
  default     = "Self Managed Env"
}

# variable for environments
variable "environment" {
  type        = string
  description = "environment"
  default     = "Live"
}

`