variable "name" {
  description = "Logical name for the EC2 instance and its security group"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID to attach the EC2 security group to"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID to launch the EC2 instance in"
  type        = string
}

variable "alb_sg_id" {
  description = "Security group ID of the ALB allowed to ingress on port 80"
  type        = string
}

variable "target_group_arn" {
  description = "ALB target group ARN to attach the instance to"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}
