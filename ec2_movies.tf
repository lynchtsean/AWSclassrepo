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

module "ec2_movies" {
  source = "./modules/ec2_instance"

  top_movies         = ["Inception", "Interstellar", "Gladiator", "TheDarkKnight", "AvengersEndgame"]
  key_name           = aws_key_pair.generated.key_name
  security_group_ids = [aws_security_group.ssh_sg.id]
}
