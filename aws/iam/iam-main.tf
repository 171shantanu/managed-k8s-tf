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

# variable for environments
variable "environment" {
  type        = string
  description = "environment"
  default     = "Live"
}
