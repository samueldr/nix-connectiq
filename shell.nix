let
  pkgs = import ./pkgs.nix;
in
  pkgs.mkShell {
    SDK_PATH = pkgs.connectiq.sdk + "/share/connectiq-sdk";
    buildInputs = [
      pkgs.connectiq.sdk
    ];
  }
