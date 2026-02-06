Create a new Puppet module named `<MODULE_NAME>` following the [Puppet Beginner's Guide to Writing Modules](https://help.puppet.com/core/8/Content/PuppetCore/bgtm.htm) pattern (install/config/service). Use the Vox Pupuli toolchain (voxpupuli-test, [voxbox](https://github.com/voxpupuli/container-voxbox)).

**Module structure:**

- `manifests/init.pp` — Main class, the only parameterized class. Use `contain` for subclasses with chaining: `install -> config ~> service`. Include parameters using `thing_property` naming (e.g., `package_ensure`, `service_name`). Add Puppet Strings `@summary`/`@param` doc comments.
- `manifests/install.pp` — Private class (`assert_private()`), manages the package. References params via `$<MODULE_NAME>::param_name`.
- `manifests/config.pp` — Private class, manages config file using an ERB template from `templates/`.
- `manifests/service.pp` — Private class, manages the service.
- `templates/<MODULE_NAME>.conf.erb` — Placeholder config template.
- `examples/init.pp` — Basic usage example.

**Vox Pupuli toolchain (not puppetlabs_spec_helper):**

- `Gemfile` — Only `gem 'voxpupuli-test', require: false`
- `Rakefile` — Only `require 'voxpupuli/test/rake'`
- `spec/spec_helper.rb` — Only `require 'voxpupuli/test/spec_helper'`
- `.fixtures.yml` — List only external forge dependencies (e.g., puppetlabs-stdlib). Do NOT add a self-symlink; voxpupuli-test handles it automatically.
- `.rubocop.yml` — Inherit from voxpupuli-test: `inherit_gem: { voxpupuli-test: rubocop.yml }`

**Tests:**

- `spec/classes/<MODULE_NAME>_spec.rb` — Use `on_supported_os` with contexts for default and custom parameters. Test compilation, class containment, and resource attributes.

**Metadata:**

- `metadata.json` — Include puppetlabs-stdlib dependency, OS support (RedHat 8/9, Ubuntu 20.04/22.04), Puppet version requirement `>= 7.0.0 < 9.0.0`.
- `.gitignore` — Ignore `pkg/`, `Gemfile.lock`, `.bundle/`, `vendor/`, `spec/fixtures/`, `.vagrant/`, `.idea/`, `*.iml`, `.*.sw?`

**After scaffolding:**

1. Initialize a git repo and commit.
2. Verify tests pass: `docker run --rm -v "$PWD:/repo" ghcr.io/voxpupuli/voxbox:8 spec`
3. Create a `CLAUDE.md` with testing commands (using docker/voxbox), architecture notes, and conventions.
4. Create a private GitHub repo and push using `gh repo create`.
