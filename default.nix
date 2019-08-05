{
  pkgs ? import <nixpkgs> {
    overlays = [ (import ./overlay) ];
    config = {
      # eww
      permittedInsecurePackages = [
        "webkitgtk-2.4.11"
      ];
    };
  }
}:

pkgs.connectiq
