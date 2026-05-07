include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "git::git@github.com:business-class-vcs/ops-infrastructure-catalog.git//modules/iam-instance-profile?ref=${values.catalog_version}"
}

inputs = {
  role_name             = values.role_name
  role_path             = try(values.role_path, "/")
  instance_profile_name = values.instance_profile_name
  instance_profile_path = try(values.instance_profile_path, "/")
  trusted_services      = try(values.trusted_services, ["ecs.amazonaws.com", "ec2.amazonaws.com"])
  inline_policies       = try(values.inline_policies, {})
  managed_policy_arns = {
    for policy_arn in try(values.managed_policy_arns, []) :
    replace(replace(policy_arn, "arn:aws:iam::aws:policy/", ""), "/", "_") => policy_arn
  }

  tags = try(values.tags, {})
}
