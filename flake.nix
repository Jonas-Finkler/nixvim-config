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

      # Overlays are not per-system, so they live outside eachDefaultSystem.
      # Expose the flake's nvim package (built per-system with allowUnfree).
      overlays.default = final: prev: {
        nvim = self.packages.${prev.stdenv.hostPlatform.system}.nvim;
      };
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
      in {
        
        packages.default = nvim;

        packages.nvim = nvim;
        
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

      }
  );
}
