include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "git::git@github.com:business-class-vcs/ops-infrastructure-catalog.git//modules/ec2-instance?ref=${values.module_version}"
}

dependency "vpc" {
  config_path = try(values.vpc_path, "../vpc")

  mock_outputs = {
    vpc_id         = "vpc-00000000"
    public_subnets = ["subnet-00000000", "subnet-00000001"]
  }
  mock_outputs_allowed_terraform_commands = ["plan", "validate", "init", "destroy"]
  mock_outputs_merge_strategy_with_state  = "shallow"
}

dependency "sg" {
  config_path = try(values.sg_path, "../security-group")

  mock_outputs = {
    security_group_id = "sg-00000000000000000"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "validate", "init", "destroy"]
  mock_outputs_merge_strategy_with_state  = "shallow"
}

inputs = {
  name                        = values.name
  instance_type               = try(values.instance_type, "t3.micro")
  subnet_id                   = dependency.vpc.outputs.public_subnets[try(values.subnet_index, 0)]
  vpc_security_group_ids      = [dependency.sg.outputs.security_group_id]
  user_data                   = try(values.user_data, null)
  associate_public_ip_address = try(values.associate_public_ip_address, false)
  iam_role_policies           = try(values.iam_role_policies, {})
  tags                        = try(values.tags, {})
}
