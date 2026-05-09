include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-ecs.git//modules/service?ref=${values.version}"
}

# Optional dependency on a sibling lb-int unit (lb-service-attachment).
# Activated when load_balancer.internal.target_group_arn == "../lb-int".
dependency "lb_int" {
  config_path  = try(values.lb_int_path, "../lb-int")
  skip_outputs = try(values.load_balancer.internal.target_group_arn, "arn:") != "../lb-int"

  mock_outputs = {
    target_groups = { service = { arn = "arn:aws:elasticloadbalancing:us-east-2:123456789012:targetgroup/mock-int/abcdef1234567890" } }
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

# Optional dependency on a sibling lb-pub unit (lb-service-attachment).
# Activated when load_balancer.public.target_group_arn == "../lb-pub".
dependency "lb_pub" {
  config_path  = try(values.lb_pub_path, "../lb-pub")
  skip_outputs = try(values.load_balancer.public.target_group_arn, "arn:") != "../lb-pub"

  mock_outputs = {
    target_groups = { service = { arn = "arn:aws:elasticloadbalancing:us-east-2:123456789012:targetgroup/mock-pub/abcdef1234567890" } }
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

locals {
  # Resolve "../lb-int" / "../lb-pub" symbolic refs to actual TG ARNs from sibling units.
  # Falls back to the literal value when skip_outputs=true (outputs = {}).
  load_balancer = {
    for k, v in try(values.load_balancer, {}) : k => merge(v, {
      target_group_arn = (
        try(v.target_group_arn, "") == "../lb-int" ?
          try(dependency.lb_int.outputs.target_groups["service"].arn, v.target_group_arn) :
        try(v.target_group_arn, "") == "../lb-pub" ?
          try(dependency.lb_pub.outputs.target_groups["service"].arn, v.target_group_arn) :
        v.target_group_arn
      )
    })
  }
}

inputs = {
  name        = values.name
  cluster_arn = values.cluster_arn

  desired_count       = try(values.desired_count, 2)
  scheduling_strategy = try(values.scheduling_strategy, "REPLICA")

  # EC2 bridge mode — network_configuration block is omitted by the module for non-awsvpc
  network_mode          = try(values.network_mode, "bridge")
  create_security_group = false
  subnet_ids            = []

  # Capacity provider strategy drives placement; no fixed launch_type
  launch_type                = null
  capacity_provider_strategy = try(values.capacity_provider_strategy, [])

  cpu    = values.cpu
  memory = values.memory

  deployment_circuit_breaker = {
    enable   = true
    rollback = true
  }
  deployment_maximum_percent         = try(values.deployment_maximum_percent, 200)
  deployment_minimum_healthy_percent = try(values.deployment_minimum_healthy_percent, 100)
  health_check_grace_period_seconds  = try(values.health_check_grace_period_seconds, 0)

  enable_execute_command = try(values.enable_execute_command, true)
  force_new_deployment   = try(values.force_new_deployment, false)
  enable_autoscaling     = try(values.enable_autoscaling, false)

  # CI/CD (GitHub Actions) owns task definition revisions — Terraform only seeds the first one
  ignore_task_definition_changes = try(values.ignore_task_definition_changes, true)

  ordered_placement_strategy = try(values.ordered_placement_strategy, [
    { type = "spread", field = "attribute:ecs.availability-zone" },
    { type = "binpack", field = "memory" },
  ])

  propagate_tags = try(values.propagate_tags, "NONE")
  load_balancer  = local.load_balancer

  # Use pre-existing IAM roles; do not let the module create new ones
  create_task_exec_iam_role = try(values.create_task_exec_iam_role, false)
  task_exec_iam_role_arn    = try(values.task_exec_iam_role_arn, null)
  create_tasks_iam_role     = try(values.create_tasks_iam_role, false)
  tasks_iam_role_arn        = try(values.tasks_iam_role_arn, null)

  container_definitions = values.container_definitions

  tags = try(values.tags, {})
}
