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
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = aws_iam_role.service_role.arn

  container_definitions = jsonencode([{
    name  = "${each.key}-container"
    image = var.container_image
    portMappings = [{
      containerPort = var.container_port
      hostPort      = var.container_port
    }]
  }])
}

resource "aws_lb_target_group" "target_groups" {
  for_each = var.cluster_names

  name     = "${each.key}-tg"
  port     = var.container_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_ecs_service" "services" {
  for_each = var.cluster_names

  name            = "${each.key}-service"
  cluster         = aws_ecs_cluster.clusters[each.key].id
  task_definition = aws_ecs_task_definition.tasks[each.key].arn
  desired_count   = var.desired_count
  iam_role        = aws_iam_role.service_role.arn

  load_balancer {
    target_group_arn = aws_lb_target_group.target_groups[each.key].arn
    container_name   = "${each.key}-container"
    container_port   = var.container_port
  }
}
