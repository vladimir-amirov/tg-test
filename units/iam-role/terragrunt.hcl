include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "git::git@github.com:business-class-vcs/ops-infrastructure-catalog.git//modules/iam-role?ref=${values.catalog_version}"
}

inputs = {
  role_name        = values.name
  role_path        = try(values.path, "/")
  role_description = try(values.description, "Allows ECS tasks to call AWS services on your behalf.")
  trusted_services = try(values.trusted_services, ["ecs-tasks.amazonaws.com"])
  inline_policies  = try(values.inline_policies, {})
  managed_policy_arns = {
    for policy_arn in try(values.managed_policy_arns, []) :
    replace(replace(policy_arn, "arn:aws:iam::aws:policy/", ""), "/", "_") => policy_arn
  }

  tags = try(values.tags, {})
}
