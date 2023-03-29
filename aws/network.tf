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

# Data block for availabilty zone
data "aws_availability_zones" "az" {
  state = "available"
}

#Adding public subnet 1
resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.k8s_vpc.id
  cidr_block              = var.public_sub_cidrs[0]
  availability_zone       = data.aws_availability_zones.az.names[0]
  map_public_ip_on_launch = true

  tags = {
    "Name" = "${local.name_suffix}-public-subnet-1"
    "AZ"   = "${data.aws_availability_zones.az.names[0]}"
  }
}

#Adding public subnet 2
resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.k8s_vpc.id
  cidr_block              = var.public_sub_cidrs[1]
  availability_zone       = data.aws_availability_zones.az.names[1]
  map_public_ip_on_launch = true

  tags = {
    "Name" = "${local.name_suffix}-public-subnet-2"
    "AZ"   = "${data.aws_availability_zones.az.names[1]}"
  }
}

#Adding private subnet 1
resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.k8s_vpc.id
  cidr_block        = var.private_sub_cidrs[0]
  availability_zone = data.aws_availability_zones.az.names[0]

  tags = {
    "Name" = "${local.name_suffix}-private-subnet-1"
    "AZ"   = "${data.aws_availability_zones.az.names[0]}"
  }
}

#Adding private subnet 2
resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.k8s_vpc.id
  cidr_block        = var.private_sub_cidrs[1]
  availability_zone = data.aws_availability_zones.az.names[1]

  tags = {
    "Name" = "${local.name_suffix}-private-subnet-2"
    "AZ"   = "${data.aws_availability_zones.az.names[1]}"
  }
}