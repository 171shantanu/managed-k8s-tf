# variable for the VPC id
variable "k8s_vpc_id" {
  default = "vpc-09e4c60947130ec2e"
}

# variable for the DB username
variable "db_username" {
  sensitive   = true
  description = "Username for the Database"
  type        = string
}

# variable for the DB password
variable "db_password" {
  sensitive   = true
  description = "Password for the Database"
  type        = string
}

# Data block to fetch the private subnet ID's 
data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [var.k8s_vpc_id]
  }

  tags = {
    "Name" = "${local.name_suffix}-private-subnet-*"
  }
}

# Data block to fetch the DB security group
data "aws_security_group" "db_sg" {
    
}

# Database Subnet group
resource "aws_db_subnet_group" "rds_group" {
  name       = "rds-subnet-group"
  subnet_ids = data.aws_subnets.private.ids

  tags = {
    "Name" = "${local.name_suffix}-rds-subnet-group"
  }
}

resource "aws_db_instance" "my_sql_instance" {
  allocated_storage    = 10
  db_name              = "mysql-db-1"
  engine               = "mysql"
  engine_version       = "8.32"
  identifier           = "mysql-db-1"
  instance_class       = "db.t3.micro"
  username             = var.db_username
  password             = var.db_password
  db_subnet_group_name = aws_db_subnet_group.rds_group.name
  skip_final_snapshot  = true
  multi_az             = false
  vpc_security_group_ids = 

}
