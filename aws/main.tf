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

# varibale for the CIDR of the public subnets 
variable "public_sub_cidr" {
  type        = list(string)
  description = "public subnet 1 CIDR"
  default     = ["10.1.1.0/24", "10.1.2.0/24"]
}

# varibale for the CIDR of the private subnets 
variable "private_sub_cidrs" {
  type        = list(string)
  description = "Private Subnet CIDR's"
  default     = ["10.1.3.0/24", "10.1.4.0/24"]
}
