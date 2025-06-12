module "ecs_cluster" {
  source           = "./modules/ecs_cluster"
  cluster_names    = {
    app1 = "App One"
    app2 = "App Two"
  }
  container_image  = "nginx:latest"
  container_port   = 8080
  cpu              = "256"
  memory           = "512"
  vpc_id           = "vpc-xxxxxxxx"
  desired_count    = 2
}
