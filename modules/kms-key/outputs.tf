output "key_id" {
  description = "The globally unique identifier for the KMS key"
  value       = aws_kms_key.this.key_id
}

output "key_arn" {
  description = "The ARN of the KMS key"
  value       = aws_kms_key.this.arn
}

output "aliases" {
  description = "Map of alias name → alias ARN"
  value       = { for k, v in aws_kms_alias.this : k => v.arn }
}
