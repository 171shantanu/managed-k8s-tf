# Declaring locals
locals {
  name_suffix = "${var.environment}-${var.project}"
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

# variable for the EC2 instance type
variable "rds_instance_type" {
  type        = string
  description = "RDS Instance Type"
  default     = "db.t3.micro"
}
