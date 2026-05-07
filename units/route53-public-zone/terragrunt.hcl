include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "git::git@github.com:business-class-vcs/terraform-aws-route53.git//public-zone?ref=${values.version}"
}

inputs = {
  name          = values.name
  comment       = try(values.comment, "Managed by Terragrunt")
  force_destroy = try(values.force_destroy, false)

  tags = try(values.tags, {})
}