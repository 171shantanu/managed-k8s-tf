# Adding Internet Gateway for the VPC
resource "aws_internet_gateway" "k8s_igw" {
  vpc_id = aws_vpc.k8s_vpc.id

  tags = {
    "Name" = "${local.name_suffix}-IGW"
  }
}
