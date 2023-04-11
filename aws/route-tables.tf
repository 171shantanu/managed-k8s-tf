# Public Route table
resource "aws_route_table" "public_1" {
  vpc_id = aws_vpc.k8s_vpc.id

  tags = {
    "Name" = "${local.name_suffix}-Public-Route-Table"
  }
}

# Route for the public route table

resource "aws_route" "public_route_1" {
  route_table_id         = aws_route_table.public_1.id
  destination_cidr_block = var.public_route
  gateway_id             = aws_internet_gateway.k8s_igw.id
  depends_on             = [aws_internet_gateway.k8s_igw]
}

# Route table for privatve subnet 1

resource "aws_route_table" "private_1" {
  vpc_id = aws_vpc.k8s_vpc.id

  tags = {
    "Name" = "${local.name_suffix}-Private-Route-Table-1"
  }
}

# Route table for privatve subnet 1

resource "aws_route_table" "private_2" {
  vpc_id = aws_vpc.k8s_vpc.id

  tags = {
    "Name" = "${local.name_suffix}-Private-Route-Table-2"
  }
}

# Associating the public RT with the public subnet 1
resource "aws_route_table_association" "public_rt_1_assoc" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public_1.id
}

# Associating the public RT with the public subnet 2
resource "aws_route_table_association" "public_rt_2_assoc" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public_1.id
}

# Associating the private RT with the private subnet 1
resource "aws_route_table_association" "private_rt_1_assoc" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private_1.id
}

# Associating the private RT with the private subnet 2
resource "aws_route_table_association" "private_rt_2_assoc" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.private_2.id
}
