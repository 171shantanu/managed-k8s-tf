# Data block for the ami of instances
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

# Resources for the key pair for the instances
resource "aws_key_pair" "k8s_key" {
  key_name   = "self-k8s-key"
  public_key = tls_private_key.rsa_k8s.public_key_openssh
  depends_on = [tls_private_key.rsa_k8s]
  lifecycle {
    prevent_destroy = true
  }
  tags = {
    "Name" = "${local.name_suffix}-key-pair"
  }
}

# Generating a rsa key for the ec2 instances to get the public key
resource "tls_private_key" "rsa_k8s" {
  algorithm = "RSA"
  rsa_bits  = 4096
  lifecycle {
    prevent_destroy = true
  }
}

# Strping the private key in the local using a local file resource block
resource "local_file" "k8s_key_private" {
  content  = tls_private_key.rsa_k8s.private_key_pem
  filename = "k8s-key.pem"
  lifecycle {
    prevent_destroy = true
  }
}

# Resource block for the AWS EC2 Instance. (Master Node)
resource "aws_instance" "k8s_master_node" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.ec2_instance_type
  key_name      = aws_key_pair.k8s_key.key_name

  tags = {
    "Name" = "K8s-master-node"
  }
}

# Resource block for the AWS EC2 Instance. (Worker Nodes)
resource "aws_instance" "k8s_worker_nodes" {
  count         = 2
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.ec2_instance_type
  key_name      = aws_key_pair.k8s_key.key_name

  tags = {
    "Name" = "K8s-worker-node"
  }
}
