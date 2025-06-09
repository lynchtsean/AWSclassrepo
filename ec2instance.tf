
# 1. Generate a new SSH key pair
resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# 2. Create AWS EC2 key pair with the public key
resource "aws_key_pair" "generated" {
  key_name   = "tf-ec2-key"
  public_key = tls_private_key.ec2_key.public_key_openssh
}

# 3. Security group to allow SSH
resource "aws_security_group" "ssh_sg" {
  name        = "allow-ssh"
  description = "Allow SSH inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
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

# 4. Launch EC2 instance using generated key
resource "aws_instance" "mcitsami" {
  ami                    = "ami-0c7217cdde317cfec"  # Amazon Linux 2023 AMI
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.generated.key_name
  vpc_security_group_ids = [aws_security_group.ssh_sg.id]

  tags = {
    Name = "EC2WithGeneratedKey"
  }
}
