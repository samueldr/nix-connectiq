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
  sdkver = "3.0.12";
  revision = "2019-06-12-77ed6f47e";

  src = fetchurl {
    url = "https://developer.garmin.com/downloads/connect-iq/sdks/connectiq-sdk-lin-${version}.zip";
    sha256 = "0pc1vgfm3gdw0bc06602k78q658r4x9144nvaidqnagn7iaq9b86";
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
