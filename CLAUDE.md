# CLAUDE.md

## Project Overview

This is a declarative Neovim configuration built with [nixvim](https://github.com/nix-community/nixvim). All configuration is written in Nix and compiled into a standalone Neovim package via a Nix flake.

## Repository Structure

```
nixvim-config/
├── flake.nix          # Nix flake: inputs, outputs, build targets
└── config/
    ├── default.nix    # Entry point; imports all config modules
    ├── plugins.nix    # Plugin declarations and settings
    ├── keymaps.nix    # Key mappings
    ├── options.nix    # Neovim options (e.g. set splitright)
    └── colorscheme.nix # Theme/colorscheme settings
```

## Common Commands

### Build & Run

```bash
# Run directly without installing
nix run .

# Enter dev shell with the configured neovim on PATH
nix develop

# Run checks (tests that neovim starts without errors)
nix flake check

# Build an AppImage (portable binary)
nix bundle --bundler github:ralismark/nix-appimage ./#nvim

# Build an AppImage using FUSE2 (for clusters without FUSE3)
nix bundle --bundler github:Jonas-Finkler/nix-appimage ./#nvim
```

### Development Workflow

```bash
# After editing any .nix file, rebuild to check for errors
nix build

# Check flake inputs are consistent
nix flake lock --no-update-lock-file
```

## Key Conventions

- **All configuration is Nix**: Do not add Lua files directly. Inline Lua goes in `__raw` strings within Nix.
- **Plugins via nixvim**: Add plugins using the `plugins.<name>.enable = true` pattern in `plugins.nix`. Check [nixvim options](https://nix-community.github.io/nixvim/) for available options.
- **Nixpkgs channel**: Currently on `nixos-unstable`. The commented-out `nixos-25.05` lines exist as a fallback for TreeSitter regressions.
- **Leader key**: `<Space>`

## LSP Servers Configured

| Language   | Server   |
|------------|----------|
| Nix        | nil_ls   |
| Python     | pyright  |
| C/C++      | clangd   |
| Fortran    | fortls   |
| LaTeX      | ltex     |
| JSON       | jsonls   |
| YAML       | yamlls   |
| Java       | jdtls    |

## Completion Sources (nvim-cmp)

Order matters — listed by priority:
1. `copilot` — GitHub Copilot inline suggestions
2. `buffer` — current buffer text
3. `treesitter` — syntax-aware completions
4. `nvim_lsp` — LSP completions
5. `path` — filesystem paths
6. `vsnip` — snippets

## Notes

- Copilot authentication: run `:Copilot auth` inside Neovim after first build.
- `jj` is preferred over `<Esc>` to exit insert mode (Telescope also maps `<Esc>` to close).
- `<Tab>` confirms completion; use `<Shift-Tab>` to insert literal whitespace without triggering cmp.
