include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  # Set LOCAL_CATALOG_PATH=/abs/path/to/ops-infrastructure-catalog to test
  # against the on-disk module without committing/pushing.
  catalog_local = get_env("LOCAL_CATALOG_PATH", "")
}

terraform {
  source = local.catalog_local != "" ? "${local.catalog_local}/modules/s3-bucket" : "git::git@github.com:business-class-vcs/ops-infrastructure-catalog.git//modules/s3-bucket?ref=${values.module_version}"
}

# Dependency on a sibling KMS key unit.
# Set values.use_kms = false (and values.sse_algorithm = "AES256") to skip this dependency.
# Override the path via values.kms_path when the key unit lives elsewhere in the stack.
dependency "kms" {
  enabled     = try(values.use_kms, true)
  config_path = try(values.kms_path, "../kms")

  mock_outputs = {
    key_arn = "arn:aws:kms:us-east-1:000000000000:key/00000000-0000-0000-0000-000000000000"
  }
  mock_outputs_allowed_terraform_commands = ["plan", "validate", "init", "destroy"]
  mock_outputs_merge_strategy_with_state  = "shallow"
}

inputs = {
  bucket             = values.bucket
  versioning_enabled = try(values.versioning_enabled, true)
  sse_algorithm      = try(values.sse_algorithm, "aws:kms")
  kms_master_key_id  = try(values.use_kms, true) ? dependency.kms.outputs.key_arn : null

  block_public_acls       = try(values.block_public_acls, true)
  block_public_policy     = try(values.block_public_policy, true)
  ignore_public_acls      = try(values.ignore_public_acls, true)
  restrict_public_buckets = try(values.restrict_public_buckets, true)

  tags = try(values.tags, {})
}
