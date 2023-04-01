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

  # Ingress for port 6443
  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Default Port for K8s API Server)"
  }

  # Ingress for port 2379-2380
  ingress {
    cidr_blocks = [aws_vpc.k8s_vpc.cidr_block]
    description = "Allowing port for etcd server client API from the VPC network only"
    from_port   = 2379
    protocol    = "tcp"
    to_port     = 2380
  }

  # Ingress for port 10250
  ingress {
    cidr_blocks = [aws_vpc.k8s_vpc.cidr_block]
    description = "Allowing port for the Kubelet API from the VPC network only"
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
  }

  # Ingress for port 10257
  ingress {
    cidr_blocks = [aws_vpc.k8s_vpc.cidr_block]
    description = "Allowing port for the Kube-scheduler from the VPC network only"
    from_port   = 10257
    to_port     = 10257
    protocol    = "tcp"
  }


  tags = {
    "Name"  = "${local.name_suffix}-Public-SG"
    "Ports" = "22, 2379-2380, 6443, 10250, 10257"
  }
}
