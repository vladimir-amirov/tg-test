include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  catalog_local = get_env("LOCAL_CATALOG_PATH", "")
}

terraform {
  source = local.catalog_local != "" ? "${local.catalog_local}/modules/lb-target-attachment" : "git::git@github.com:business-class-vcs/ops-infrastructure-catalog.git//modules/lb-target-attachment?ref=${values.module_version}"
}

dependency "alb" {
  config_path = try(values.alb_path, "../alb")

  mock_outputs = {
    target_groups = {
      instances = {
        arn = "arn:aws:elasticloadbalancing:us-east-1:000000000000:targetgroup/mock/0000000000000000"
      }
    }
  }
  mock_outputs_allowed_terraform_commands = ["plan", "validate", "init", "destroy"]
  mock_outputs_merge_strategy_with_state  = "shallow"
}

dependency "target" {
  config_path = try(values.target_path, "../ec2-instance")

  mock_outputs = {
    id = "i-00000000000000000"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "validate", "init", "destroy"]
  mock_outputs_merge_strategy_with_state  = "shallow"
}

inputs = {
  target_group_arn = dependency.alb.outputs.target_groups[try(values.target_group_key, "instances")].arn
  target_id        = dependency.target.outputs.id
  port             = try(values.port, 80)
}
