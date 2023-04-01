# Data block for my IPv4
data "http" "my_ip" {
  url = "http://ipv4.icanhazip.com/"
}

# Resource block for the SG
resource "aws_security_group" "public_sg" {
  name        = "Public_SG"
  description = "Allows Acces on PORT 22,80 & 443"
  vpc_id      = aws_vpc.k8s_vpc.id

  # Ingress for port 22

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.my_ip.response_body)}/32"]
    description = "Allowing SSH access from my computer"
  }

  # Engress for port 22
  egress {
    cidr_blocks = ["${chomp(data.http.my_ip.response_body)}/32"]
    description = "Allowing SSH access from my computer"
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
  }

  tags = {
    "Name"  = "${local.name_suffix}-Public-SG"
    "Ports" = "22, 80, 443"
  }
}

# Resource block for the SG Rule for port 22 Ingress 
