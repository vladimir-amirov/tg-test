include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "git::git@github.com:business-class-vcs/terraform-aws-s3.git//app?ref=${values.version}"
}

inputs = {
  bucket        = values.bucket
  force_destroy = try(values.force_destroy, false)

  versioning = try(values.versioning, {
    status = "Enabled"
  })

  server_side_encryption_configuration = try(values.server_side_encryption_configuration, {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
      bucket_key_enabled = true
    }
  })

  block_public_acls       = try(values.block_public_acls, true)
  block_public_policy     = try(values.block_public_policy, true)
  ignore_public_acls      = try(values.ignore_public_acls, true)
  restrict_public_buckets = try(values.restrict_public_buckets, true)

  tags = try(values.tags, {})
}
