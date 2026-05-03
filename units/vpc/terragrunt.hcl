include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  # Прямая ссылка на модуль из Terraform Registry — без локальной обёртки.
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
