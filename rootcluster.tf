module "ecs_cluster" {
  source        = "./modules/ecs_cluster"
  cluster_names = {
    "lynch-cluster"   = "lynch-cluster"
    "antoine-cluster" = "antoine-cluster"
    "ovadia-cluster"  = "ovadia-cluster"
    "negar-cluster"   = "negar-cluster"
    "onome-cluster"   = "onome-cluster"
  }
  container_image  = "nginx:latest"
  container_port   = 8080
  cpu              = "256"
  memory           = "512"
  vpc_id           = "vpc-xxxxxxxx"
  desired_count    = 2
}
