output "instance_id" {
  description = "EC2 instance ID (use for SSM session)"
  value       = module.ec2.id
}

output "private_ip" {
  description = "Private IP of the EC2 instance"
  value       = module.ec2.private_ip
}
