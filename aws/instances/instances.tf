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

# Resource block for the AWS EC2 Instance. (Master Node)
resource "aws_instance" "k8s_master_node" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.ec2_instance_type
  key_name      = aws_key_pair.k8s_key.key_name

  tags = {
    "Name" = "K8s-master-node-1"
  }
}

# Resource block for the EBS volume of the Master Node Instance.
resource "aws_ebs_volume" "master_node_ebs_volume" {
  availability_zone = module.aws.data.aws_availability_zones.az
}

# Resource block for the AWS EC2 Instances. (Worker Nodes)
resource "aws_instance" "k8s_worker_nodes" {
  count         = 2
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.ec2_instance_type
  key_name      = aws_key_pair.k8s_key.key_name

  tags = {
    "Name" = "K8s-worker-node-2"
  }
}
