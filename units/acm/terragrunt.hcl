include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "git::git@github.com:business-class-vcs/terraform-aws-acm.git//app?ref=${values.version}"
}

dependency "zone" {
  config_path = try(values.zone_path, "../zone")

  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
  mock_outputs = {
    zone = {
      id   = "Z0000000000000000"
      name = "mock.example.com"
    }
  }
}

inputs = {
  domain_name               = values.domain_name
  subject_alternative_names = try(values.subject_alternative_names, [])
  validation_method         = "DNS"
  zone_id                   = try(values.zone_id, null) != null ? values.zone_id : dependency.zone.outputs.zone.id
  wait_for_validation       = try(values.wait_for_validation, true)

  tags = try(values.tags, {})
}
