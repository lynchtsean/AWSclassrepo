output "cluster_ids" {
  value = { for k, c in aws_ecs_cluster.clusters : k => c.id }
}

output "service_arns" {
  value = tomap({
    for name, svc in aws_ecs_service.services :
    name => lookup(svc, "arn", "no-arn-found")
  })
}
