locals {
  service     = values.service
  environment = values.environment

  bucket_name = "bc-${values.service}-${values.environment}"

  common_tags = merge(try(values.tags, {}), {
    Stack       = "example-service"
    Service     = values.service
    Environment = values.environment
    ManagedBy   = "Terragrunt"
  })
}

unit "s3" {
  source = "git::git@github.com:business-class-vcs/infrastructure-bc-catalog.git//units/s3?ref=${values.catalog_version}"
  path   = "s3"

  values = {
    version = values.module_version

    bucket        = local.bucket_name
    force_destroy = try(values.s3_force_destroy, false)

    tags = local.common_tags
  }
}
