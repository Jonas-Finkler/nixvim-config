{
  description = "My personal nixvim configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixvim.url = "github:nix-community/nixvim";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, nixvim }:
    let
      # Light build: same config with the heavy language servers dropped
      # (see config/default.nix). For headless/low-space hosts like the Pi.
      lightModule = { imports = [ (import ./config) ]; profile.light = true; };

      # One definition, shared by the overlay and packages.*. Needs a pkgs with
      # allowUnfree (copilot).
      mkNvim = pkgs: module:
        nixvim.legacyPackages.${pkgs.stdenv.hostPlatform.system}.makeNixvimWithModule {
          inherit pkgs module;
        };
    in
    {
      nixvim-config = import ./config;

      # Overlays are not per-system, so they live outside eachDefaultSystem.
      # Built from `final`, so nvim reuses the consumer's package set instead of
      # instantiating a second nixpkgs.
      overlays.default = final: prev: {
        nvim = mkNvim final (import ./config);
        nvim-light = mkNvim final lightModule;
      };
    } // flake-utils.lib.eachDefaultSystem (system:
      let
        # Standalone use (nix run, appimage bundles): apply our own overlay to
        # our own nixpkgs, so packages.* and the overlay can't drift.
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true;
          };
          overlays = [ self.overlays.default ];
        };
      in {

        packages = {
          inherit (pkgs) nvim nvim-light;
          default = pkgs.nvim;
        };

        # create appimage
        # nix bundle --bundler github:ralismark/nix-appimage ./#nvim

        # for an appimage using fuse2 instead of fuse3 (which is not installed on some clusters)
        # nix bundle --bundler github:Jonas-Finkler/nix-appimage ./#nvim

        checks.default = nixvim.lib.${system}.check.mkTestDerivationFromNixvimModule {
          inherit pkgs;
          module = import ./config;
        };

        devShells.default = pkgs.mkShell {
          buildInputs = [
            pkgs.nvim
          ];

          shellHook = ''
            # remember that we're in a dev env
            export FLAKE="nixvim"
            # back to zsh
            exec zsh
          '';
        };

      }
  );
}
