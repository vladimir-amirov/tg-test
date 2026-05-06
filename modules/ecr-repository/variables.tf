variable "name" {
  description = "Full ECR repository name as it will appear in AWS"
  type        = string
}

variable "image_tag_mutability" {
  description = "MUTABLE or IMMUTABLE. Use IMMUTABLE for production to prevent tag overwrites."
  type        = string
  default     = "MUTABLE"
}

variable "force_delete" {
  description = "If true, allow deleting repositories that contain images"
  type        = bool
  default     = false
}

variable "encryption_type" {
  description = "AES256 or KMS"
  type        = string
  default     = "AES256"
}

variable "kms_key" {
  description = "KMS key ARN. Required when encryption_type = KMS, ignored otherwise."
  type        = string
  default     = null
}

variable "scan_on_push" {
  description = "Scan images on push for vulnerabilities"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags applied to the repository"
  type        = map(string)
  default     = {}
}
