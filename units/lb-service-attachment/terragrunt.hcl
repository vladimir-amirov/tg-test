include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  # Same module as units/alb — used here with create_lb=false to attach a target group
  # and listener rule to an existing ALB listener without touching the ALB itself.
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-alb.git//?ref=${values.version}"
}

inputs = {
  create_lb             = false
  create_security_group = false
  vpc_id                = values.vpc_id

  target_groups = {
    service = {
      name        = values.target_group_name
      protocol    = try(values.protocol, "HTTP")
      port        = try(values.port, 80)
      target_type = try(values.target_type, "instance")

      health_check = {
        enabled             = true
        path                = try(values.health_check_path, "/health")
        matcher             = try(values.health_check_matcher, "200-299")
        interval            = try(values.health_check_interval, 30)
        timeout             = try(values.health_check_timeout, 5)
        healthy_threshold   = try(values.healthy_threshold, 3)
        unhealthy_threshold = try(values.unhealthy_threshold, 3)
      }
    }
  }

  listeners = {
    # Referencing an existing listener by ARN — the module creates rules on it
    # without creating a new listener (requires create_lb = false).
    main = {
      arn = values.listener_arn

      rules = {
        service = {
          priority = values.rule_priority

          conditions = [{
            host_header = {
              values = values.host_headers
            }
          }]

          actions = [{
            type             = "forward"
            target_group_key = "service"
          }]
        }
      }
    }
  }

  tags = try(values.tags, {})
}
