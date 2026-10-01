# On PATH so codediff.nvim skips downloading it into its read-only store dir.
# Match VERSION in codediff.nvim's lua/codediff/core/installer/watcher.lua.
{ rustPlatform, fetchFromGitHub, git }:
rustPlatform.buildRustPackage rec {
  pname = "codediff-watcher";
  version = "0.23.2";
  src = fetchFromGitHub {
    owner = "esmuellert";
    repo = "codediff";
    rev = "v${version}";
    hash = "sha256-YiDCNp5buIYQhnquC/1hjLGBjGtzSMu6BAgHtcYCt5o=";
  };
  cargoHash = "sha256-wiyDnyYop2lbmUVt5H4SiizaE4Kl5pAkBn5r8c3M9UI=";
  cargoBuildFlags = [ "-p" "watcher" "--bin" "codediff-watcher" ];
  cargoTestFlags = [ "-p" "watcher" ];
  nativeCheckInputs = [ git ];
}
