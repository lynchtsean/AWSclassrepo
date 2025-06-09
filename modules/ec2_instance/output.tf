output "ec2_public_ips" {
  description = "Public IPs of EC2 instances"
  value = {
    for name, instance in aws_instance.ec2_movies :
    name => instance.public_ip
  }
}

output "ec2_instance_ids" {
  description = "Instance IDs of EC2 instances"
  value = {
    for name, instance in aws_instance.ec2_movies :
    name => instance.id
  }
}
