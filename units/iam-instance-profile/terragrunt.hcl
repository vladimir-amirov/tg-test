include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-iam.git//modules/iam-role?ref=${values.module_version}"
}

inputs = {
  name                    = values.name
  use_name_prefix         = false
  create_instance_profile = true

  trust_policy_permissions = {
    TrustedServices = {
      actions = ["sts:AssumeRole"]
      principals = [{
        type        = "Service"
        identifiers = try(values.trusted_services, ["ecs.amazonaws.com", "ec2.amazonaws.com"])
      }]
    }
  }

  create_inline_policy          = length(try(values.inline_policies, {})) > 0
  source_inline_policy_documents = values(try(values.inline_policies, {}))
  policies = {
    for policy_arn in try(values.managed_policy_arns, []) :
    replace(replace(policy_arn, "arn:aws:iam::aws:policy/", ""), "/", "_") => policy_arn
  }

  tags = try(values.tags, {})
}
