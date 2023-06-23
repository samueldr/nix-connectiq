let
  nixpkgs' =
    let
      owner  = "NixOS";
      repo   = "Nixpkgs";
      rev    = "3c15feef7770eb5500a4b8792623e2d6f598c9c1"; # nixos-unstable @ 2023-09-06
      sha256 = "sha256:11z6ajj108fy2q5g8y4higlcaqncrbjm3dnv17pvif6avagw4mcb";
    in
    builtins.fetchTarball {
      url = "https://github.com/${owner}/${repo}/archive/${rev}.tar.gz";
      inherit sha256;
    }
  ;
  config = (import nixpkgs' {}).config;
in
import nixpkgs' {
  overlays = [ (import ./overlay) ];
  config = config // {
    allowUnfree = true;
  };
}
