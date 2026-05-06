include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  catalog_local = get_env("LOCAL_CATALOG_PATH", "")
}

terraform {
  source = local.catalog_local != "" ? "${local.catalog_local}/modules/ecr-repository" : "git::git@github.com:business-class-vcs/ops-infrastructure-catalog.git//modules/ecr-repository?ref=${values.module_version}"
}

inputs = {
  name                 = values.name
  image_tag_mutability = try(values.image_tag_mutability, "MUTABLE")
  force_delete         = try(values.force_delete, false)
  encryption_type      = try(values.encryption_type, "AES256")
  kms_key              = try(values.kms_key, null)
  scan_on_push         = try(values.scan_on_push, true)
  tags                 = try(values.tags, {})
}
