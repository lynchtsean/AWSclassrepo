variable "AWS_ACCESS_KEY"{
  type=string
}
variable "AWS_CLIENT_SECRET"{
  type=string
}
variable "cluster_names" {
  type    = set(string)
  default = ["lynch-cluster", "antoine-cluster", "ovadia-cluster", "negar-cluster", "onome-cluster"]
}
