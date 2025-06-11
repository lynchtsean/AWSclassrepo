resource "aws_ecs_service" "lynch" {
  name            = "lynch-service"
  cluster         = aws_ecs_cluster.lynch_cluster.id
  task_definition = aws_ecs_task_definition.lynch.arn
  desired_count   = 3
  iam_role        = aws_iam_role.lynch_service_role.arn
  depends_on      = [aws_iam_role_policy.lynch_service_policy]

  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.lynch_tg.arn
    container_name   = "lynch-container"
    container_port   = 8080
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [us-west-2a, us-west-2b]"
  }
}
