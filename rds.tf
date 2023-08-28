# Definindo o provedor AWS
#provider "aws" {
#  region = "us-east-2"
#}

# Criando a VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Criando as subnets
resource "aws_subnet" "subnet1" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
}

resource "aws_subnet" "subnet2" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
}

# Criando a instância RDS em Aurora ProSQL
resource "aws_rds_cluster" "my_cluster" {
  cluster_identifier  = "my-cluster"
  engine              = "aurora-postgresql"
  engine_version      = "15.3"
  database_name       = "mydb"
  master_username     = "dbadmin"
  master_password     = "password"
  port                = 5432
  skip_final_snapshot = true
  vpc_security_group_ids = [aws_security_group.my_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.my_subnet_group.name
}

resource "aws_db_subnet_group" "my_subnet_group" {
  name       = "my-subnet-group"
  subnet_ids = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
}

resource "aws_security_group" "my_sg" {
  name        = "my-security-group"
  description = "Allow inbound traffic for RDS"
  vpc_id      = aws_vpc.my_vpc.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Criando a keypair
resource "aws_key_pair" "my_keypair" {
  key_name   = "ssh-key"
  key_name      = aws_key_pair.ssh-key.key_name
}

# Configurando o backend S3
#terraform {
#  backend "s3" {
#    bucket = "terraformstate8479374"
#    key    = "rdsterraform01/terraform.tfstate"
#    region = "us-east-1"
#  }
#}
