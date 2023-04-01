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

# Data block for the ID of public subnet 1
data "aws_subnet" "public_1" {
  filter {
    name   = "tag:Name"
    values = ["${local.name_suffix}-public-subnet-1"]
  }
}

# Data block for the ID of public subnet 2
data "aws_subnet" "public_2" {
  filter {
    name   = "tag:Name"
    values = ["${local.name_suffix}-public-subnet-2"]
  }
}

# Data block for getting the master node Security group
data "aws_security_group" "master_node_sg" {
  filter {
    name   = "tag:Name"
    values = ["${local.name_suffix}-Master-Node-SG"]
  }
}

# Resource block for the AWS EC2 Instance. (Master Node)
resource "aws_instance" "k8s_master_node" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.ec2_instance_type
  key_name               = aws_key_pair.k8s_key.key_name
  availability_zone      = data.aws_availability_zones.az.names[0]
  subnet_id              = data.aws_subnet.public_1.id
  vpc_security_group_ids = [data.aws_security_group.master_node_sg.id]

  root_block_device {
    volume_size = 10
    volume_type = "gp2"
    tags = {
      "Name" = "K8s-master-node-ebs-volume"
      "Size" = "10"
    }
  }
  tags = {
    "Name" = "K8s-master-node"
    "AZ"   = "${data.aws_availability_zones.az.names[0]}"
  }
}

# Data block for getting the worker node Security group
data "aws_security_group" "worker_node_sg" {
  filter {
    name   = "tag:Name"
    values = ["${local.name_suffix}-Worker-Node-SG"]
  }
}

# Resource block for the AWS EC2 Instances. (Worker Nodes)
resource "aws_instance" "k8s_worker_nodes" {
  count                  = 2
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.ec2_instance_type
  key_name               = aws_key_pair.k8s_key.key_name
  availability_zone      = data.aws_availability_zones.az.names[count.index]
  subnet_id              = count.index == 0 ? data.aws_subnet.public_1.id : data.aws_subnet.public_2.id
  vpc_security_group_ids = [data.aws_security_group.worker_node_sg.id]

  root_block_device {
    volume_size = 10
    volume_type = "gp2"
    tags = {
      "Name" = "K8s-worker-node-${count.index + 1}-ebs-volume"
      "Size" = "10"
    }
  }

  tags = {
    "Name" = "K8s-worker-node-${count.index + 1}"
  }
}
