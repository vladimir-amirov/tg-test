include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "git::git@github.com:business-class-vcs/terraform-aws-iam.git//iam-role?ref=${values.version}"
}

inputs = {
  name                  = values.name
  description           = try(values.description, "Allows ECS tasks to call AWS services on your behalf.")
  trusted_services      = try(values.trusted_services, ["ecs-tasks.amazonaws.com"])
  force_detach_policies = try(values.force_detach_policies, false)

  inline_policies     = try(values.inline_policies, {})
  managed_policy_arns = try(values.managed_policy_arns, [])

  tags = try(values.tags, {})
}
