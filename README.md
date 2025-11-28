# vfox-bashly

A [vfox](https://github.com/version-fox/vfox) plugin for [bashly](https://bashly.dannyb.co/) - a command line application (in Bash) framework and target.

## Installation

```bash
# With mise
mise install vfox:mise-plugins/vfox-bashly@1.2.0

# With vfox
vfox add mise-plugins/vfox-bashly
vfox install bashly@1.2.0
```

## Requirements

- Ruby (for running bashly via bundler)

## Usage

```bash
# With mise
mise use vfox:mise-plugins/vfox-bashly@1.2.0
bashly --version

# Or run directly
mise x vfox:mise-plugins/vfox-bashly@1.2.0 -- bashly --help
```

## How it works

This plugin installs bashly via Ruby's bundler with an isolated gem environment. Each version gets its own:
- `GEM_HOME` directory
- `Gemfile` with the specific bashly version
- Wrapper script that sets up the correct environment

## License

Apache-2.0
