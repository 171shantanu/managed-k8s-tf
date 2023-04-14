# Declaring locals
locals {
  name_suffix = "${var.environment}-${var.project}"
}

# variable for project
variable "project" {
  type        = string
  description = "Project Name"
  default     = "Self Managed Env"
}

# variable for environment
variable "environment" {
  type        = string
  description = "environment"
  default     = "Live"
}

# variable for the EC2 instance type
variable "ec2_instance_type" {
  type        = string
  description = "EC2 Instance Type"
  default     = "t2.micro"
}
