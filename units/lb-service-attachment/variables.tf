variable "vpc_id" {
  description = "VPC ID for the target group"
  type        = string
}

variable "target_group_name" {
  description = "Name of the target group"
  type        = string
}

variable "protocol" {
  description = "Protocol for the target group"
  type        = string
  default     = "HTTP"
}

variable "port" {
  description = "Port for the target group"
  type        = number
  default     = 80
}

variable "target_type" {
  description = "Target type: instance, ip, or lambda"
  type        = string
  default     = "instance"
}

variable "health_check_path" {
  description = "Health check path"
  type        = string
  default     = "/health"
}

variable "health_check_matcher" {
  description = "HTTP status codes that indicate a healthy response"
  type        = string
  default     = "200-299"
}

variable "health_check_interval" {
  description = "Health check interval in seconds"
  type        = number
  default     = 30
}

variable "health_check_timeout" {
  description = "Health check timeout in seconds"
  type        = number
  default     = 5
}

variable "healthy_threshold" {
  description = "Number of consecutive successful checks before marking healthy"
  type        = number
  default     = 3
}

variable "unhealthy_threshold" {
  description = "Number of consecutive failed checks before marking unhealthy"
  type        = number
  default     = 3
}

variable "listener_arn" {
  description = "ARN of the existing ALB listener to attach a rule to"
  type        = string
}

variable "rule_priority" {
  description = "Listener rule priority (1–50000, unique per listener)"
  type        = number
}

variable "host_headers" {
  description = "Host header values that trigger this listener rule"
  type        = list(string)
}

variable "tags" {
  description = "Tags applied to all resources"
  type        = map(string)
  default     = {}
}
