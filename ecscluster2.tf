variable "cluster_names" {
  type    = set(string)
  default = ["lynch-cluster", "antoine-cluster", "ovadia-cluster", "negar-cluster", "onome-cluster"]
}

resource "aws_ecs_cluster" "clusters" {
  for_each = var.cluster_names
  name     = each.key
}

resource "aws_iam_role" "service_role" {
  name = "ecs-service-role"
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

resource "aws_ecs_task_definition" "tasks" {
  for_each = var.cluster_names

  family                   = "${each.key}-task"
  network_mode             = "bridge"
  requires_compatibilities = ["EC2"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.service_role.arn

  container_definitions = jsonencode([{
    name  = "${each.key}-container"
    image = "mongo"   # Replace with your image
    portMappings = [{
      containerPort = 8080
      hostPort      = 8080
    }]
  }])
}

resource "aws_lb_target_group" "target_groups" {
  for_each = var.cluster_names

  name     = "${each.key}-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = "vpc-xxxxxxxx"  
}

resource "aws_ecs_service" "services" {
  for_each = var.cluster_names

  name            = "${each.key}-service"
  cluster         = aws_ecs_cluster.clusters[each.key].id
  task_definition = aws_ecs_task_definition.tasks[each.key].arn
  desired_count   = 3
  iam_role        = aws_iam_role.service_role.arn

  load_balancer {
    target_group_arn = aws_lb_target_group.target_groups[each.key].arn
    container_name   = "${each.key}-container"
    container_port   = 8080
  }
}
