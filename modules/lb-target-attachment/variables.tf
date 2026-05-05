variable "target_group_arn" {
  description = "ARN of the target group to attach to"
  type        = string
}

variable "target_id" {
  description = "ID of the target (instance ID, IP, or Lambda ARN)"
  type        = string
}

variable "port" {
  description = "Port on which the target receives traffic"
  type        = number
}
