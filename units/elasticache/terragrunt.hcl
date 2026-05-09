include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-elasticache.git//?ref=${values.version}"
}

inputs = {
  # TODO: implement
}
