output "cluster_ids" {
  value = { for k, c in aws_ecs_cluster.clusters : k => c.id }
}

output "service_arns" {
  value = { for k, s in aws_ecs_service.services : k => s.arn }
}
