resource "aws_instance" "ec2_movies" {
  for_each = toset(var.top_movies)

  ami                    = "ami-0c7217cdde317cfec"
  instance_type          = "t2.micro"
  key_name               = var.key_name                
  vpc_security_group_ids = var.security_group_ids      

  tags = {
    Name = each.key
  }
}

