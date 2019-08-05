let
  config = (import <nixpkgs> {}).config;
in
import <nixpkgs> {
  overlays = [ (import ./overlay) ];

  # This allows importing the user's own allowUnfree setting.
  config = config // {
    # eww
    permittedInsecurePackages = [
      "webkitgtk-2.4.11"
    ];
  };
}
