# Terragrunt Units Directory

This directory contains reusable [Terragrunt units](https://terragrunt.gruntwork.io/docs/features/units/) for deploying AWS infrastructure.

Each unit represents a single piece of infrastructure that can be composed together to create complete stacks.

## What are Units?

A **unit** is a directory containing a `terragrunt.hcl` file that represents a single piece of infrastructure.

You can think of a unit as a single instance of a Terraform module. Units can be combined together into [stacks](https://terragrunt.gruntwork.io/docs/features/stacks/) to create complete environments.

## What's Inside?

Each unit in this directory:
- References a corresponding OpenTofu/Terraform module (in this repo's `modules/` directory or in a separate module repo)
- Defines input variables using the `values.*` pattern
- Manages dependencies between other units
- Includes environment-specific naming conventions

## How to Use?

Refer to the [stacks directory](../stacks/) to see how `units` are composed together.

## Folder Structure: Flat by Convention

This catalog uses a **flat** unit layout, following the [official Gruntwork example](https://github.com/gruntwork-io/terragrunt-infrastructure-catalog-example/tree/main/units). Units are kebab-cased and named descriptively. Composition lives in `stacks/`, not in directory paths.

```
units/
├── acm-certificate/
├── alb/
├── ecs-cluster/
├── ecs-service/
├── ecs-task-definition/
├── github-oidc-provider/
├── github-repo-secrets/
├── iam-role/
├── iam-role-ecs-task/
├── iam-role-github-actions/
├── rds-postgres/
├── route53-hosted-zone-private/
├── route53-hosted-zone-public/
├── s3-bucket/
├── secrets-manager-secret/
└── vpc/
```

### Why Flat?

1. **`terragrunt catalog` / `scaffold` commands** present units as a searchable list. Flat + kebab-case sorts cleanly in the TUI.
2. **Composition belongs in stacks, not paths.** A stack is where resources like an ECS cluster, ACM certificate, Route53 zone, ALB, and IAM roles get wired together. Putting Route53 under `ecs/`, for example, conflates *consumer* with *owner* — Route53 zones are owned by the network/DNS layer and merely consumed by ECS services via ALB alias records.
3. **Path stability.** Nesting couples consumers to layout. Moving `units/ecs/route53/` → `units/route53/` would break every stack referencing it. Flat directories give stable, long-lived identifiers.
4. **Composite names encode intent.** `iam-role-ecs-task` is one unit with a clear purpose; you don't need `iam/ecs/task/role/` to convey the same meaning.

### Naming Conventions

- **Resource-only units** name the resource: `vpc`, `alb`, `acm-certificate`, `route53-hosted-zone-public`.
- **Composite / purpose-specific units** describe the purpose: `iam-role-github-actions`, `iam-role-ecs-task`.
- **Service families** share a prefix: `ecs-*`, `rds-*`, `iam-*`, `route53-*`, `s3-*`.
- Use prefixes for alphabetical clustering — never nested directories.
