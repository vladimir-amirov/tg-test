variable "description" {
  description = "Human-readable description of the KMS key"
  type        = string
  default     = "Managed by Terragrunt"
}

variable "deletion_window_in_days" {
  description = "Waiting period (7–30 days) before the key is deleted after destroy"
  type        = number
  default     = 30

  validation {
    condition     = var.deletion_window_in_days >= 7 && var.deletion_window_in_days <= 30
    error_message = "deletion_window_in_days must be between 7 and 30."
  }
}

variable "enable_key_rotation" {
  description = "Automatically rotate the key annually (recommended for compliance)"
  type        = bool
  default     = true
}

variable "policy" {
  description = "JSON key policy document. When null, AWS creates the default policy (root account full access)."
  type        = string
  default     = null
}

variable "aliases" {
  description = "List of alias names without the 'alias/' prefix, e.g. [\"prod-s3-key\"]"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags applied to the KMS key"
  type        = map(string)
  default     = {}
}
