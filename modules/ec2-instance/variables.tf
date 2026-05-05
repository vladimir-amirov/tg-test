variable "name" {
  description = "Logical name for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "subnet_id" {
  description = "Subnet ID to launch the instance in"
  type        = string
}

variable "vpc_security_group_ids" {
  description = "List of VPC security group IDs to attach to the instance"
  type        = list(string)
}

variable "user_data" {
  description = "User data content (raw string). Pass null to skip."
  type        = string
  default     = null
}

variable "associate_public_ip_address" {
  description = "Whether to assign a public IP at launch"
  type        = bool
  default     = false
}

variable "iam_role_policies" {
  description = "Map of {label = policy_arn} to attach to the instance role. Empty map = no instance profile."
  type        = map(string)
  default     = {}
}

variable "ami_owners" {
  description = "List of AMI owners to filter by"
  type        = list(string)
  default     = ["amazon"]
}

variable "ami_name_filter" {
  description = "List of AMI name patterns (used in the 'name' filter)"
  type        = list(string)
  default     = ["al2023-ami-2023*-x86_64"]
}

variable "root_volume_size" {
  description = "Root EBS volume size in GiB"
  type        = number
  default     = 8
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
