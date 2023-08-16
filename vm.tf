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
  
  user_data = file("${path.module}/user_data.sh")

  tags = {
    Name = "EC2-Instance"
  }
}

resource "aws_ebs_volume" "ebs_volume" {
  availability_zone = aws_instance.ec2_instance.availability_zone
  size              = 80
  type              = "gp2"  # Tipo de volume EBS (gp2 é o padrão e é apropriado para a maioria dos casos)
}

resource "aws_volume_attachment" "ebs_attachment" {
  device_name = "/dev/sdf"  # Nome do dispositivo na instância
  volume_id   = aws_ebs_volume.ebs_volume.id
  instance_id = aws_instance.ec2_instance.id
}







