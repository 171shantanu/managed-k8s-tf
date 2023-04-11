# Data block to fetch the private subnet ID's 
data "aws_subnets" "private" {
  filter {
    name   = "tag:Name"
    values = ["${local.name_suffix}-private-subnet-*"]
  }
}

# Data block to fetch the DB security group
data "aws_security_group" "db_sg" {
  filter {
    name   = "tag:Name"
    values = ["${local.name_suffix}-Database-SG"]
  }
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
  allocated_storage      = 10
  db_name                = "mysqldb1"
  engine                 = "mysql"
  engine_version         = "8.0.32"
  identifier             = "mysql-db-1"
  instance_class         = var.rds_instance_type
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.rds_group.name
  skip_final_snapshot    = true
  multi_az               = false
  vpc_security_group_ids = [data.aws_security_group.db_sg.id]
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
