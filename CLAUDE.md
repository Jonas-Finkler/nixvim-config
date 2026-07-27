# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A declarative Neovim configuration built with [NixVim](https://github.com/nix-community/nixvim), distributed as a Nix flake. The entire Neovim environment — plugins, LSP servers, keymaps, options — is expressed in Nix.

## Common Commands

```bash
# Check/validate the configuration
nix flake check

# Run Neovim directly from the flake
nix run .

# Build the package
nix build .#nvim

# Enter dev shell (provides nvim + zsh)
nix develop

# Bundle as AppImage (for portability)
nix bundle --bundler github:ralismark/nix-appimage ./#nvim

# Bundle as AppImage (FUSE2, for HPC clusters)
nix bundle --bundler github:Jonas-Finkler/nix-appimage ./#nvim
```

## Architecture

```
flake.nix          # Flake definition: inputs, outputs, system matrix, nixpkgs config
config/
  default.nix      # Root module — imports all other modules
  plugins.nix      # All plugin declarations and configurations
  keymaps.nix      # Key bindings (leader = <Space>)
  options.nix      # Neovim options (tabs, UI, search, clipboard, etc.)
  colorscheme.nix  # Theme: onedark "warmer", transparent background
  copilotPrompt.txt  # Custom system prompt for copilot-chat
```

All modules are imported by `config/default.nix`, which is the single entry point for the NixVim module.

## How the Flake Is Structured

`flake.nix` uses `flake-utils.lib.eachDefaultSystem` to produce per-system outputs. The nixvim configuration is built with `nixvim.legacyPackages.${system}.makeNixvimWithModule`, taking `config/default.nix` as the module. `allowUnfree = true` is set (required for Copilot).

Outputs per system:
- `packages.default` / `packages.nvim` — the Neovim derivation
- `checks.default` — validation derivation via `nixvimLib.check.mkTestDerivationFromNixvimModule`
- `devShells.default` — shell with nvim + zsh
- `overlays.default` — exposes nvim as a nixpkgs overlay

## Adding Plugins

All plugins live in `config/plugins.nix`. NixVim wraps nixvim plugin options under `programs.nixvim.plugins.<name>`. To add a plugin:

1. Add `programs.nixvim.plugins.<name>.enable = true;` in `plugins.nix`
2. Add any plugin-specific settings under the same attribute path
3. Run `nix flake check` to validate

## LSP Servers

Configured in `config/plugins.nix` under `programs.nixvim.plugins.lsp.servers`. Currently enabled: `nil_ls` (Nix), `ltex` (LaTeX/prose), `pyright` (Python), `clangd` (C/C++), `fortls` (Fortran), `jsonls`, `yamlls`, `jdtls` (Java).

**Gotcha — server `settings` namespacing:** NixVim already wraps a server's `settings` under that server's own config key. For `nil_ls` it emits `settings = { ["nil"] = { ... } }` for you, so write `settings.nix.flake.autoArchive = true;` — NOT `settings."nil".nix...`. Adding the server key yourself double-nests it (`settings.nil.nil.nix...`), the LSP silently never sees the option, and it may keep nagging (e.g. nil's "enable auto-archive" prompt on every Nix file). To verify what actually reaches the server, build with `nix build .#nvim` and grep the generated `init.lua` (path is in `result/bin/nvim`) for the setting.

## Known Issues (tracked in flake.nix comments)

Currently pinned to `nixos-unstable`. Two known Treesitter regressions on this channel:
- Python comments not greyed out
- LaTeX syntax highlighting broken
