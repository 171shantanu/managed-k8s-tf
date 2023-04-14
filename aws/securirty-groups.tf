# Data block for my IPv4
data "http" "my_ip" {
  url = "http://ipv4.icanhazip.com/"
}

# Resource block for the SG
resource "aws_security_group" "master_node_sg" {
  name        = "Master_Node_SG"
  description = "SG for the master node"
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
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["${chomp(data.http.my_ip.response_body)}/32"]
    description = "Allowing SSH access from my computer"
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.my_ip.response_body)}/32"]
    description = "Allowing 8080 port for jenkins access from my computer"
  }

  # Engress for port 22
  egress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.my_ip.response_body)}/32"]
    description = "Allowing 8080 port for jenkins access from my computer"
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

  # Ingress for port 10259
  ingress {
    cidr_blocks = [aws_vpc.k8s_vpc.cidr_block]
    description = "Allowing port for the Kube-controller-manager from the VPC network only"
    from_port   = 10259
    to_port     = 10259
    protocol    = "tcp"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allowing access from internet"
  }
  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allowing access from internet"
  }

    ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allowing access from internet"
  }
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allowing access from internet"
  }

  tags = {
    "Name"    = "${local.name_suffix}-Master-Node-SG"
    "Ports"   = "22, 2379-2380, 6443, 10250, 10257"
    "Purpose" = "SG-for-Master-Node"
  }
}

# Resource block for security group for the worker node
resource "aws_security_group" "worker_node_sg" {
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

  # Ingress for port 10250
  ingress {
    from_port   = 10250
    to_port     = 10250
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.k8s_vpc.cidr_block]
    description = "Allowing port for the Kubelet API from the VPC network only"
  }

  # Ingress for port 30000-32767
  ingress {
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allowing port for the NodePort Service"
  }

  tags = {
    "Name"    = "${local.name_suffix}-Worker-Node-SG"
    "Ports"   = "22, 10250, 30000-32767"
    "Purpose" = "SG-for-Worker-Node"
  }
}

resource "aws_security_group" "db_security_group" {
  name        = "Database_SG"
  description = "Allows Acces on PORT 3306"
  vpc_id      = aws_vpc.k8s_vpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.public_1.cidr_block, aws_subnet.public_2.cidr_block]
    description = "Allowing access on port 3306 for MySQL"
  }
  egress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.public_1.cidr_block, aws_subnet.public_2.cidr_block]
    description = "Allowing access on port 3306 for MySQL"
  }

  tags = {
    "Name"    = "${local.name_suffix}-Database-SG"
    "Ports"   = "3306"
    "Purpose" = "SG-for-Database"
  }
}
