{
  description = "My personal nixvim configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixvim.url = "github:nix-community/nixvim";
    # BUG: Changing to stable channels because unstable is a bit buggy (TreeSitter): 
    # - Comments in python are highlighted and not greyed out
    # - Highlighting in LaTeX is broken
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    # nixvim.url = "github:nix-community/nixvim/nixos-25.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, nixvim }: {
      nixvim-config = import ./config;
    } // flake-utils.lib.eachDefaultSystem (system: 
      let 
        pkgs = import nixpkgs { 
          inherit system; 
          config = {
            allowUnfree = true;
          };
        };

        nixvim' = nixvim.legacyPackages.${system};
        nixvimLib = nixvim.lib.${system};
        nixvimModule = {
          inherit pkgs;
          module = import ./config;
        };
        nvim = nixvim'.makeNixvimWithModule nixvimModule;

        # Light build: same config with the heavy language servers dropped
        # (see config/default.nix). For headless/low-space hosts like the Pi.
        nvim-light = nixvim'.makeNixvimWithModule {
          inherit pkgs;
          module = { imports = [ (import ./config) ]; profile.light = true; };
        };
      in {

        packages.default = nvim;

        packages.nvim = nvim;
        packages.nvim-light = nvim-light;
        
        # create appimage
        # nix bundle --bundler github:ralismark/nix-appimage ./#nvim

        # for an appimage using fuse2 instead of fuse3 (which is not installed on some clusters)
        # nix bundle --bundler github:Jonas-Finkler/nix-appimage ./#nvim

        checks.default = nixvimLib.check.mkTestDerivationFromNixvimModule nixvimModule;

        devShells.default = pkgs.mkShell {
          buildInputs = [
            nvim
          ];

          shellHook = ''
            # remember that we're in a dev env
            export FLAKE="nixvim"
            # back to zsh
            exec zsh
          '';
        };

        overlays = [
          (final: prev: {
            inherit nvim nvim-light;
          })
        ];

      }
  );
}
