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

# variable for project
variable "project" {
  type        = string
  description = "Project Name"
  default     = "Self Managed k8s"
}

# variable for environment
variable "environment" {
  type        = string
  description = "environment"
  default     = "Live"
}
