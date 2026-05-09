include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-route53.git//modules/records?ref=${values.version}"
}

inputs = {
  # TODO: implement
}
