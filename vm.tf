resource "aws_key_pair" "ssh-key" {
  key_name   = "ssh-key"
  public_key = var.aws_pub_key  # Substitua pelo caminho da sua chave pública SSH
}

resource "aws_instance" "ec2_instance" {
  ami           = "ami-08a52ddb321b32a8c"  # Substitua pelo ID da AMI desejada
  instance_type = "t2.micro"
  key_name      = aws_key_pair.ssh-key.key_name
  subnet_id     = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.ssh.id]  # Associa o grupo de segurança à instância
  
  user_data = <<-EOF
    
   #!/bin/bash
    sudo yum update
    sudo yum -y install docker
    sudo service docker start
    sudo usermod -a -G docker ec2-user
    sudo chkconfig docker on
    sudo curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    EOF

  tags = {
    Name = "EC2-Instance"
  }
}
