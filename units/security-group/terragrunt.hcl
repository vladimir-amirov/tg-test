include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  # Direct reference to a module from the Terraform Registry — no local wrapper.
  source = "tfr:///terraform-aws-modules/security-group/aws?version=${values.module_version}"
}

dependency "vpc" {
  config_path = try(values.vpc_path, "../vpc")

  mock_outputs = {
    vpc_id = "vpc-00000000"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "validate", "init", "destroy"]
  mock_outputs_merge_strategy_with_state  = "shallow"
}

dependency "source_sg" {
  enabled     = try(values.source_sg_path, null) != null
  config_path = try(values.source_sg_path, "../source-sg")

  mock_outputs = {
    security_group_id = "sg-00000000000000000"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "validate", "init", "destroy"]
  mock_outputs_merge_strategy_with_state  = "shallow"
}

inputs = {
  name        = values.name
  description = try(values.description, "Managed by Terragrunt")
  vpc_id      = dependency.vpc.outputs.vpc_id

  ingress_with_source_security_group_id = try(values.source_sg_path, null) != null ? [
    {
      from_port                = values.ingress_port
      to_port                  = values.ingress_port
      protocol                 = "tcp"
      description              = try(values.ingress_description, "From source SG")
      source_security_group_id = dependency.source_sg.outputs.security_group_id
    }
  ] : []

  ingress_with_cidr_blocks = try(values.ingress_with_cidr_blocks, [])

  egress_rules = try(values.egress_rules, ["all-all"])

  tags = try(values.tags, {})
}
