include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  # Direct reference to a module from the Terraform Registry — no local wrapper.
  source = "tfr:///terraform-aws-modules/vpc/aws?version=${values.module_version}"
}

inputs = {
  name = values.name
  cidr = values.cidr

  azs            = values.azs
  public_subnets = values.public_subnets

  enable_dns_hostnames = true
  enable_dns_support   = true
}
