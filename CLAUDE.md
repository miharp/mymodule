# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a Puppet module (`myorg-mymodule`) using the Vox Pupuli toolchain. It follows the standard install/config/service pattern with a single parameterized main class.

## Testing

Tests run inside the **voxbox** container (not locally). Always use Docker:

```bash
# Run all unit tests
docker run --rm -v "$PWD:/repo" ghcr.io/voxpupuli/voxbox:8 spec

# Run a single spec file
docker run --rm -e "SPEC=spec/classes/mymodule_spec.rb" -v "$PWD:/repo" ghcr.io/voxpupuli/voxbox:8 spec

# Lint Puppet manifests
docker run --rm -v "$PWD:/repo" ghcr.io/voxpupuli/voxbox:8 lint

# Validate syntax
docker run --rm -v "$PWD:/repo" ghcr.io/voxpupuli/voxbox:8 syntax

# RuboCop
docker run --rm --entrypoint rubocop -v "$PWD:/repo" ghcr.io/voxpupuli/voxbox:8

# Interactive shell for debugging
docker run --rm -it --entrypoint ash -v "$PWD:/repo" ghcr.io/voxpupuli/voxbox:8
```

## Architecture

The module uses the Puppet **roles and profiles** install/config/service pattern:

- `manifests/init.pp` — The **only** parameterized class. Contains all parameters and uses `contain` with chaining arrows to enforce ordering: `install -> config ~> service`.
- `manifests/install.pp` — Package resources. Private class (uses `assert_private()`), reads parameters from the main class via `$mymodule::param_name`.
- `manifests/config.pp` — File resources using ERB templates from `templates/`.
- `manifests/service.pp` — Service resources. Notified (`~>`) by config changes.

All subclasses are private (`@api private`, enforced with `assert_private()`). New parameters must be added to `init.pp` only, then referenced in subclasses via `$mymodule::param_name`.

## Conventions

- **Parameter naming**: Use `thing_property` pattern (e.g., `package_ensure`, `service_name`).
- **Test framework**: `voxpupuli-test` gem (not `puppetlabs_spec_helper`). Spec helper is `require 'voxpupuli/test/spec_helper'`, rake tasks are `require 'voxpupuli/test/rake'`.
- **Fixtures**: `.fixtures.yml` lists only external dependencies. Do not add a self-symlink — `voxpupuli-test` handles it automatically.
- **RuboCop**: Config inherits from `voxpupuli-test` gem via `.rubocop.yml`.
- **Puppet Strings**: All classes and parameters use `@summary`/`@param` doc comments for REFERENCE.md generation.
- **OS coverage**: Tests use `on_supported_os` from `rspec-puppet-facts`, driven by `operatingsystem_support` in `metadata.json` (RedHat 8/9, Ubuntu 20.04/22.04).
