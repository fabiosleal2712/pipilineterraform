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
    echo "Hello, this is user data!" > user_data.txt
    EOF

  tags = {
    Name = "EC2-Instance"
  }
}
