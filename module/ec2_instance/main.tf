resource "aws_instance" "ec2_movies" {
  for_each = toset(var.top_movies)

  ami                    = "ami-0c7217cdde317cfec"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.generated.key_name
  vpc_security_group_ids = [aws_security_group.ssh_sg.id]

  tags = {
    Name = each.key
  }
}

