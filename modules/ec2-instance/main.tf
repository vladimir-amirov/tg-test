data "aws_ami" "selected" {
  count = var.ami_id == null ? 1 : 0

  most_recent = true
  owners      = var.ami_owners

  filter {
    name   = "name"
    values = var.ami_name_filter
  }
}

locals {
  ami_id = coalesce(var.ami_id, try(data.aws_ami.selected[0].id, null))
}

module "ec2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 5.7"

  name = var.name

  ami                         = local.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.vpc_security_group_ids
  associate_public_ip_address = var.associate_public_ip_address

  user_data                   = var.user_data
  user_data_replace_on_change = true

  create_iam_instance_profile = length(var.iam_role_policies) > 0
  iam_role_policies           = var.iam_role_policies

  metadata_options = {
    http_tokens   = "required"
    http_endpoint = "enabled"
  }

  root_block_device = [{
    encrypted   = true
    volume_size = var.root_volume_size
    volume_type = "gp3"
  }]

  tags = var.tags
}
