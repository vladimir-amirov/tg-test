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

  # AMI selection: explicit ami_id wins; otherwise the module's lookup uses
  # owners + name_filter (with sensible defaults inside the module).
  ami_id          = try(values.ami_id, null)
  ami_owners      = try(values.ami_owners, ["amazon"])
  ami_name_filter = try(values.ami_name_filter, ["al2023-ami-2023*-x86_64"])

  tags = try(values.tags, {})
}
