include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "git::git@github.com:business-class-vcs/terraform-aws-iam.git//iam-instance-profile?ref=${values.version}"
}

inputs = {
  name             = values.name
  trusted_services = try(values.trusted_services, ["ecs.amazonaws.com", "ec2.amazonaws.com"])

  inline_policies     = try(values.inline_policies, {})
  managed_policy_arns = try(values.managed_policy_arns, [])

  tags = try(values.tags, {})
}
