include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "tfr:///terraform-aws-modules/iam/aws//modules/iam-instance-profile?version=${values.version}"
}

inputs = {
  # TODO: implement
}
