# Nixvim Configuration

A declarative Neovim configuration using [nixvim](https://github.com/nix-community/nixvim). This configuration provides a modern development environment with features like LSP support, fuzzy finding, Git integration, and GitHub Copilot.

## Features

- **LSP Integration** with support for:
  - Nix (nil_ls)
  - Python (pyright)
  - C/C++ (clangd)
  - Fortran (fortls)
  - LaTeX (ltex)
  - JSON/YAML
- **AI Assistance** via GitHub Copilot with:
  - Inline completions (copilot-lua)
  - Chat interface (copilot-chat)
- **Modern Development Tools**
  - Telescope for fuzzy finding
  - Treesitter for syntax highlighting
  - Git integration via gitsigns
  - Buffer management with bufferline
  - Smart code completion (nvim-cmp)

## Prerequisites

- Nix package manager with flakes enabled
- Git
- (Optional) GitHub account for Copilot features

## Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/Jonas-Finkler/nixvim-config.git
   ```

2. Run directly using:
   ```bash
   nix run github:Jonas-Finkler/nixvim-config
   ```

3. Or create an AppImage (two options):
   ```bash
   # Standard version
   nix bundle --bundler github:ralismark/nix-appimage ./#nvim

   # Version using FUSE2 (for some clusters)
   nix bundle --bundler github:Jonas-Finkler/nix-appimage ./#nvim
   ```

## Plugin Overview

### Development Tools
- **Treesitter** - Advanced syntax highlighting and code understanding
- **LSP** - Language Server Protocol support for multiple languages
  - Nix (nil_ls)
  - Python (pyright)
  - C/C++ (clangd)
  - Fortran (fortls)
  - LaTeX (ltex)
  - JSON/YAML
- **nvim-cmp** - Smart code completion with multiple sources:
  - Copilot suggestions
  - Buffer text
  - Treesitter syntax
  - LSP completions
  - File paths
  - Snippets

### Navigation & Search
- **Telescope** - Fuzzy finder for:
  - Project files
  - Live grep (text search)
  - Buffer management
  - Current buffer search
- **bufferline** - Buffer tabs management
- **indent-blankline** - Visual indent guides

### Git Integration
- **gitsigns** - Git change indicators in buffer

### Documentation & Preview
- **markdown-preview** - Live Markdown preview in browser
- **todo-comments** - Highlight and track TODO/FIXME/NOTE comments

### AI Assistance
- **copilot-lua** - GitHub Copilot integration
  - Inline code suggestions
  - Integration with nvim-cmp
- **copilot-chat** - Interactive AI chat interface
  - Customizable chat window
  - Context-aware responses
  - Multiple AI models support

## Key Mappings

Leader key is `<Space>`

### File Navigation
- `<leader>f` - Find files in project
- `<leader>g` - Live grep (search text in project)
- `<leader>b` - Browse open buffers
- `<leader>cb` - Search in current buffer

### LSP Features
- `K` - Hover documentation
- `gr` - Find references
- `gd` - Go to definition
- `gD` - Go to declaration
- `gi` - Go to implementation
- `gt` - Go to type definition
- `<leader>ca` - Code actions
- `<leader>sh` - Show signature help
- `<leader>rn` - Rename symbol
- `<leader>wa` - Add workspace folder
- `<leader>wr` - Remove workspace folder

### Diagnostics
- `<leader>j` - Go to next diagnostic
- `<leader>k` - Go to previous diagnostic
- `<leader>e` - Open diagnostic float

### Completion
- `<c-j>` - Select next completion item
- `<c-k>` - Select previous completion item
- `<tab>` - Confirm completion

### Copilot Chat
- `<c-space>` - Submit prompt
- `<c-e>` - Close chat
- `<c-r>` - Reset chat
- `gd` - Show diff (in chat)

### Telescope Navigation
- `<esc>` or `<c-e>` - Exit telescope
- Use normal vim navigation within results

## Configuration Structure

```
nixvim-config/
├── flake.nix          # Nix flake configuration
└── config/
    ├── default.nix    # Main configuration entry
    ├── plugins.nix    # Plugin configurations
    ├── keymaps.nix    # Key mappings
    ├── options.nix    # Neovim options
    └── colorscheme.nix # Theme settings
```

## License

See the [LICENSE](./LICENSE) file for details.
