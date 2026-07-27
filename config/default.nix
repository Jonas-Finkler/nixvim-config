{ lib, ... }: {
  imports = [
    ./options.nix
    ./colorscheme.nix
    ./keymaps.nix
    ./plugins.nix
  ];

  # Light profile: drop the heavy LSP servers/toolchains (clang, rust, java,
  # python, ...) and copilot/markdown-preview. Keeps highlighting, keymaps and
  # completion. For headless/low-space hosts (e.g. the Pi). See flake.nix's nvim-light.
  options.profile.light = lib.mkEnableOption "minimal profile (no heavy language servers)";
}
