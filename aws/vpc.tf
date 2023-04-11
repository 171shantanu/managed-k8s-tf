# VPC resource
resource "aws_vpc" "k8s_vpc" {
  # CIDR block for the VPC.
  cidr_block = "10.1.0.0/16"

  # Making the instances in this VPC shared on a host. (Dedicated hosts will incure additional charges from AWS) 
  instance_tenancy = "default"

  # EKS requires the VPC to have DNS support enabled.
  enable_dns_support = true

  # EKS requires the VPC to have DNS Hostnames enabled.
  enable_dns_hostnames = true

  # Disabling the IPv6 for the VPC
  assign_generated_ipv6_cidr_block = false
  tags = {
    "Name" = "${local.name_suffix}-VPC"
  }
}
