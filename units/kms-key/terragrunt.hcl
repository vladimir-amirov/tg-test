include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  # Set LOCAL_CATALOG_PATH=/abs/path/to/ops-infrastructure-catalog to test
  # against the on-disk module without committing/pushing.
  catalog_local = get_env("LOCAL_CATALOG_PATH", "")
}

terraform {
  source = local.catalog_local != "" ? "${local.catalog_local}/modules/kms-key" : "git::git@github.com:business-class-vcs/ops-infrastructure-catalog.git//modules/kms-key?ref=${values.module_version}"
}

inputs = {
  description             = try(values.description, "Managed by Terragrunt")
  deletion_window_in_days = try(values.deletion_window_in_days, 30)
  enable_key_rotation     = try(values.enable_key_rotation, true)
  policy                  = try(values.policy, null)
  aliases                 = try(values.aliases, [])
  tags                    = try(values.tags, {})
}
