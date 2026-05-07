variable "role_name" {
  description = "Name of the IAM role."
  type        = string
}

variable "role_path" {
  description = "Path of the IAM role."
  type        = string
  default     = "/"
}

variable "role_description" {
  description = "Description of the IAM role."
  type        = string
  default     = null
}

variable "instance_profile_name" {
  description = "Name of the IAM instance profile."
  type        = string
}

variable "instance_profile_path" {
  description = "Path of the IAM instance profile."
  type        = string
  default     = "/"
}

variable "trusted_services" {
  description = "AWS service principals that can assume the role."
  type        = list(string)
  default     = ["ecs.amazonaws.com", "ec2.amazonaws.com"]
}

variable "inline_policies" {
  description = "Map of inline policy names to JSON policy documents."
  type        = map(string)
  default     = {}
}

variable "managed_policy_arns" {
  description = "Map of managed policy names to policy ARNs."
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Tags to add to all supported resources."
  type        = map(string)
  default     = {}
}
