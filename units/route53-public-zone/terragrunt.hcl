include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "tfr:///terraform-aws-modules/route53/aws//modules/zones?version=${values.version}"
}

inputs = {
  # TODO: implement
}
