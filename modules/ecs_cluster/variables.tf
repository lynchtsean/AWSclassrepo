variable "cluster_names" {
  type = map(string)
  description = "Map of cluster names."
}

variable "container_image" {
  type        = string
  description = "Docker image for container."
  default     = "mongo"
}

variable "container_port" {
  type        = number
  description = "Port the container exposes."
  default     = 8080
}

variable "cpu" {
  type        = string
  description = "CPU units for the task."
  default     = "256"
}

variable "memory" {
  type        = string
  description = "Memory for the task."
  default     = "512"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID for the load balancer."
}

variable "desired_count" {
  type        = number
  description = "Number of tasks to run."
  default     = 3
}
