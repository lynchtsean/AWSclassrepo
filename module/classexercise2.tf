variable "top_movies" {
  description = "Top 5 favorite movies to name EC2 instances"
  type        = list(string)
  default     = ["Inception", "Interstellar", "Gladiator", "TheDarkKnight", "AvengersEndgame"]
}

resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated" {
  key_name   = "tf-ec2-key"
  public_key = tls_private_key.ec2_key.public_key_openssh
}

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

resource "aws_instance" "ec2_movies" {
  for_each = toset(var.top_movies)

  ami                    = "ami-0c7217cdde317cfec" # Amazon Linux 2023 AMI (check your region)
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.generated.key_name
  vpc_security_group_ids = [aws_security_group.ssh_sg.id]

  tags = {
    Name = each.key
  }
}
