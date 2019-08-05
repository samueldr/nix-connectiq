{ stdenv
, fetchurl
, jdk8
, unzip
, runtimeShell
, autoPatchelfHook

# autoPatchelfHook libraries
, libusb1
, zlib
, webkitgtk24x-gtk2
, xlibs
, libjpeg
, libpng

# Configuration
, beta ? false
, sdkver
, revision
, sha256
}:

let
  inherit (stdenv.lib) makeBinPath;
  binPath = makeBinPath [
    jdk8
  ];
in
stdenv.mkDerivation rec {
  pname = "connectiq-sdk";
  version = "${sdkver}-${revision}";

  src = fetchurl {
    url = "https://developer.garmin.com/downloads/connect-iq${if beta then "/beta" else ""}/sdks/connectiq-sdk-lin-${version}.zip";
    inherit sha256;
  };

  unpackPhase = ''
    (
    mkdir -p sdk
    cd sdk
    unzip -qq ${src}
    )
  '';

  sdkpath = "${placeholder "out"}/share/connectiq-sdk";

  nativeBuildInputs = [
    unzip
    autoPatchelfHook
  ];

  buildInputs = [
    libusb1
    zlib
    webkitgtk24x-gtk2
    xlibs.libXxf86vm
    libjpeg
    libpng
  ];

  installPhase = ''
    mkdir -p $sdkpath
    rmdir $sdkpath
    mv sdk $sdkpath

    mkdir -p $out/bin
    for f in $sdkpath/bin/*; do
      if test -x $f; then
        echo "Adding a shim for '$f'"
    cat > "$out/bin/$(basename $f)" <<EOF
    #${runtimeShell}
    PATH="${binPath}:$PATH"
    exec "$f" "\$@"
    EOF
        chmod +x "$out/bin/$(basename $f)"
      fi
    done
  '';
}
