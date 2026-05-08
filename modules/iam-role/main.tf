module "iam_role" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-iam.git//modules/iam-role?ref=v6.2.3"

  name            = var.role_name
  use_name_prefix = false
  path            = var.role_path
  description     = var.role_description

  trust_policy_permissions = {
    TrustedServices = {
      actions = ["sts:AssumeRole"]
      principals = [{
        type        = "Service"
        identifiers = var.trusted_services
      }]
    }
  }

  policies = var.managed_policy_arns
  tags     = var.tags
}

resource "aws_iam_role_policy" "this" {
  for_each = var.inline_policies

  name   = each.key
  role   = module.iam_role.name
  policy = each.value
}
