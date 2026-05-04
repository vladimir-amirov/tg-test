include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  # Wrapper-модуль из этого же каталога — версия пробрасывается через values.module_version,
  # которая в стек-файле обычно совпадает с тегом каталога (catalog_version).
  source = "git::git@github.com:business-class-vcs/ops-infrastructure-catalog.git//modules/ec2-2048?ref=${values.module_version}"
}

dependency "vpc" {
  config_path = values.vpc_path

  mock_outputs = {
    vpc_id         = "vpc-00000000"
    public_subnets = ["subnet-00000000", "subnet-00000001"]
  }
  mock_outputs_allowed_terraform_commands = ["plan", "validate", "init", "destroy"]
  mock_outputs_merge_strategy_with_state  = "shallow"
}

dependency "alb" {
  config_path = values.alb_path

  mock_outputs = {
    security_group_id = "sg-00000000000000000"
    target_groups = {
      instances = {
        arn = "arn:aws:elasticloadbalancing:us-east-1:000000000000:targetgroup/mock/0000000000000000"
      }
    }
  }
  mock_outputs_allowed_terraform_commands = ["plan", "validate", "init", "destroy"]
  mock_outputs_merge_strategy_with_state  = "shallow"
}

inputs = {
  name             = values.name
  vpc_id           = dependency.vpc.outputs.vpc_id
  subnet_id        = dependency.vpc.outputs.public_subnets[0]
  alb_sg_id        = dependency.alb.outputs.security_group_id
  target_group_arn = dependency.alb.outputs.target_groups["instances"].arn
  instance_type    = try(values.instance_type, "t3.micro")
}
