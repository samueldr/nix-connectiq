{ stdenv
, fetchurl
, jdk8
, unzip
, runtimeShell
, writeScript
, autoPatchelfHook

# autoPatchelfHook libraries
, gcc-unwrapped
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
    gcc-unwrapped.lib
    libusb1
    zlib
    webkitgtk24x-gtk2
    xlibs.libXxf86vm
    libjpeg
    libpng
  ];

  installPhase =
    let
      mkShim = binary: ''
        echo "Adding a shim for '${binary}'"
        cat > $out/bin/${binary} <<EOF
        #${runtimeShell}
        SDK="$sdkpath"
        PATH="${binPath}:$PATH"
        exec $sdkpath/bin/${binary} "\$@"
        EOF
        chmod +x $out/bin/${binary}
      '';
    in
  ''
    mkdir -p $sdkpath
    rmdir $sdkpath
    mv sdk $sdkpath

    mkdir -p $out/bin
    ${mkShim "barrelbuild"}
    ${mkShim "barreltest"}
    ${mkShim "connectiq"}
    ${mkShim "connectiqpkg"}
    ${mkShim "monkeyc"}
    ${mkShim "monkeydo"}
    ${mkShim "monkeygraph"}
    ${mkShim "shell"}
    ${mkShim "simulator"}
  '';

  passthru = {
    inherit sdkpath;
  };
}
