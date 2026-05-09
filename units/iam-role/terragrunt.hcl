include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-iam.git//modules/iam-assumable-role?ref=${values.version}"
}

inputs = {
  # TODO: implement
}
