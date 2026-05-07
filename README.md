# infrastructure-bc-catalog

Reusable Terragrunt building blocks for BC infrastructure.

## Layout

```
units/    # Building blocks — each wraps a single OpenTofu module
stacks/   # Compositions of units, parameterized via `values.xxx`
```

## Conventions

- **Modules live in separate repos.** Units reference them via `git::` URL pinned to `${values.version}`.
- **Stacks are versioned via Git tags.** Live repo references stacks/units with `?ref=<tag>`.
- **No environment-specific values here** — everything is parameterized through `values`.

## Adding a new unit

1. Create `units/<name>/terragrunt.hcl`.
2. Reference the module repo: `git::git@github.com:business-class-vcs/terraform-aws-<name>.git//app?ref=${values.version}`.
3. Pull inputs from `values.*` with sensible defaults via `try()`.
4. Provide `mock_outputs` on every `dependency` block so `validate` / `plan` work without applying.

## Adding a new stack

1. Create `stacks/<name>/terragrunt.stack.hcl`.
2. Compose `unit` blocks pointing at this catalog: `git::git@github.com:business-class-vcs/infrastructure-bc-catalog.git//units/<name>?ref=${values.catalog_version}`.
3. Use `"../<unit>"` reference strings to wire dependencies — the unit resolves them to `dependency.<unit>.outputs.*`.

## Consumed by

- [`infrastructure-bc-live`](../infrastructure-bc-live) — environment-specific deployments.
