resource "aws_ecs_cluster" "lynch_cluster" {
  name = "lynch-cluster"
}

resource "aws_iam_role" "lynch_service_role" {
  name = "lynch-service-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ecs.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy" "lynch_service_policy" {
  name = "lynch-service-policy"
  role = aws_iam_role.lynch_service_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = ["logs:*"],
      Resource = "*"
    }]
  })
}

resource "aws_ecs_task_definition" "lynch" {
  family                   = "lynch-task"
  network_mode             = "bridge"
  requires_compatibilities = ["EC2"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.lynch_service_role.arn

  container_definitions = jsonencode([{
    name  = "lynch-container",
    image = "mongo", # Replace with your Docker image
    portMappings = [{
      containerPort = 8080,
      hostPort      = 8080
    }]
  }])
}

resource "aws_lb_target_group" "lynch_tg" {
  name        = "lynch-tg"
  port        = 8080
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = "vpc-xxxxxxxx" # Replace with your actual VPC ID
}
