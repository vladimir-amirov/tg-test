include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "tfr:///terraform-aws-modules/security-group/aws?version=${values.version}"
}

inputs = {
  # TODO: implement
}
