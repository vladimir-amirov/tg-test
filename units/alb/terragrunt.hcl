include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "tfr:///terraform-aws-modules/alb/aws?version=${values.version}"
}

inputs = {
  name    = values.name
  vpc_id  = values.vpc_id
  subnets = values.subnet_ids

  security_groups            = try(values.security_group_ids, [])
  internal                   = try(values.internal, false)
  enable_deletion_protection = try(values.enable_deletion_protection, false)

  listeners = try(values.listeners, {})

  tags = try(values.tags, {})
}
