include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-ecs.git//modules/cluster?ref=${values.version}"
}

locals {
  # Normalize the nested managed_scaling object so callers pass a flat or nested map
  autoscaling_capacity_providers = {
    for k, v in try(values.autoscaling_capacity_providers, {}) : k => {
      auto_scaling_group_arn         = v.auto_scaling_group_arn
      managed_termination_protection = try(v.managed_termination_protection, "ENABLED")
      managed_draining               = try(v.managed_draining, "ENABLED")
      managed_scaling = {
        maximum_scaling_step_size = try(v.managed_scaling.maximum_scaling_step_size, 2)
        minimum_scaling_step_size = try(v.managed_scaling.minimum_scaling_step_size, 1)
        status                    = try(v.managed_scaling.status, "ENABLED")
        target_capacity           = try(v.managed_scaling.target_capacity, 100)
        instance_warmup_period    = try(v.managed_scaling.instance_warmup_period, 0)
      }
    }
  }
}

inputs = {
  name = values.name

  cluster_settings = [
    {
      name  = "containerInsights"
      value = try(values.container_insights, "disabled")
    }
  ]

  autoscaling_capacity_providers     = local.autoscaling_capacity_providers
  default_capacity_provider_strategy = try(values.default_capacity_provider_strategy, [])

  tags = try(values.tags, {})
}
