output "role_name" {
  description = "Name of the IAM role."
  value       = module.iam_role.name
}

output "role_arn" {
  description = "ARN of the IAM role."
  value       = module.iam_role.arn
}

output "instance_profile_name" {
  description = "Name of the IAM instance profile."
  value       = aws_iam_instance_profile.this.name
}

output "instance_profile_arn" {
  description = "ARN of the IAM instance profile."
  value       = aws_iam_instance_profile.this.arn
}

output "instance_profile_unique_id" {
  description = "Stable and unique string identifying the IAM instance profile."
  value       = aws_iam_instance_profile.this.unique_id
}
