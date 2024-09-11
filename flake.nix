{
  description = "My personal nixvim configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    nixvim.url = "github:nix-community/nixvim";
  };

  outputs = { self, nixpkgs, flake-utils, nixvim }:
    flake-utils.lib.eachDefaultSystem (system: 
      let 
        pkgs = import nixpkgs { 
          inherit system; 
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
