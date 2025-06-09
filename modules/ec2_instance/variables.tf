variable "key_name" {
  description = "Name of the EC2 key pair"
  type        = string
}

variable "security_group_ids" {
  description = "List of security group IDs to assign"
  type        = list(string)
}
