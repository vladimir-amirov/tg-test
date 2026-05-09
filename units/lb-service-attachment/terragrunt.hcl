include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  # Module lives alongside this file — avoids pulling in terraform-aws-modules/alb
  # which always creates an ALB and cannot create only a TG + listener rule.
  source = "./"
}

inputs = {
  vpc_id            = values.vpc_id
  target_group_name = values.target_group_name
  listener_arn      = values.listener_arn
  rule_priority     = values.rule_priority
  host_headers      = values.host_headers

  protocol    = try(values.protocol, "HTTP")
  port        = try(values.port, 80)
  target_type = try(values.target_type, "instance")

  health_check_path     = try(values.health_check_path, "/health")
  health_check_matcher  = try(values.health_check_matcher, "200-299")
  health_check_interval = try(values.health_check_interval, 30)
  health_check_timeout  = try(values.health_check_timeout, 5)
  healthy_threshold     = try(values.healthy_threshold, 3)
  unhealthy_threshold   = try(values.unhealthy_threshold, 3)

  tags = try(values.tags, {})
}
