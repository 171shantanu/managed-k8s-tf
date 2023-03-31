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

# Data block for availabilty zone
data "aws_availability_zones" "az" {
  state = "available"
}

# Resource block for the AWS EC2 Instance. (Master Node)
resource "aws_instance" "k8s_master_node" {
  ami               = data.aws_ami.ubuntu.id
  instance_type     = var.ec2_instance_type
  key_name          = aws_key_pair.k8s_key.key_name
  availability_zone = data.aws_availability_zones.az.names[0]
  tags = {
    "Name" = "K8s-master-node"
    "AZ"   = "${data.aws_availability_zones.az.names[0]}"
  }
}

# Resource block for the EBS volume of the Master Node Instance.
resource "aws_ebs_volume" "master_node_ebs_volume" {
  availability_zone = data.aws_availability_zones.az.names[0]
  size              = 10
  type              = "gp2"

  tags = {
    "Name" = "K8s-master-node-ebs-volume"
    "Size" = "10"
  }
}

# Attaching EBS Volume to the Master Node 
resource "aws_volume_attachment" "master_node_volume_attachment" {
  device_name = "/dev/sda1"
  volume_id   = aws_ebs_volume.master_node_ebs_volume.id
  instance_id = aws_instance.k8s_master_node.id
}

# Resource block for the AWS EC2 Instances. (Worker Nodes)
resource "aws_instance" "k8s_worker_nodes" {
  count             = 2
  ami               = data.aws_ami.ubuntu.id
  instance_type     = var.ec2_instance_type
  key_name          = aws_key_pair.k8s_key.key_name
  availability_zone = count.index % 2 == 0 ? data.aws_availability_zones.az.names[0] : data.aws_availability_zones.az.names[1]

  tags = {
    "Name" = "K8s-worker-node-${count.index + 1}"
  }
}

# Resource block for the EBS volume of the Worker Node Instance.
resource "aws_ebs_volume" "worker_node_ebs_volume" {
  availability_zone = count.index % 2 == 0 ? data.aws_availability_zones.az.names[0] : data.aws_availability_zones.az.names[1]
  type              = "gp2"
  count             = 2
  size              = 10
  tags = {
    "Name" = "K8s-worker-node-ebs-volume"
    "Size" = "10"
  }
}
