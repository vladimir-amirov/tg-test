include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "tfr:///terraform-aws-modules/rds/aws?version=${values.version}"
}

inputs = {
  # TODO: implement
}
