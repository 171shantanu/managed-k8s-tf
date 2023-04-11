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

# variable for project
variable "project" {
  type        = string
  description = "Project Name"
  default     = "Self Managed k8s"
}

# variable for environments
variable "environment" {
  type        = string
  description = "environment"
  default     = "Live"
}

# variable for the DB username
variable "db_username" {
  sensitive   = true
  description = "Username for the Database"
  type        = string
}

# variable for the DB password
variable "db_password" {
  sensitive   = true
  description = "Password for the Database"
  type        = string
}
