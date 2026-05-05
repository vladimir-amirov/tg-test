output "id" {
  description = "EC2 instance ID"
  value       = module.ec2.id
}

output "private_ip" {
  description = "Private IP of the instance"
  value       = module.ec2.private_ip
}

output "public_ip" {
  description = "Public IP of the instance (if assigned)"
  value       = module.ec2.public_ip
}

output "iam_role_arn" {
  description = "IAM role ARN attached to the instance, if created"
  value       = try(module.ec2.iam_role_arn, null)
}
