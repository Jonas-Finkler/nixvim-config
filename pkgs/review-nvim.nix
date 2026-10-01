# :Review: annotate a codediff view and export the comments as markdown (not in nixpkgs)
{ vimUtils, fetchFromGitHub, vimPlugins }:
vimUtils.buildVimPlugin rec {
  pname = "review-nvim";
  version = "1.10.1";
  src = fetchFromGitHub {
    owner = "georgeguimaraes";
    repo = "review.nvim";
    rev = "v${version}";
    hash = "sha256-Wc4jPQ44bZKoJ8pidtL9N79nPBNBwqnn1XkGW+2bQbQ=";
  };
  dependencies = [ vimPlugins.codediff-nvim vimPlugins.nui-nvim ];
}
