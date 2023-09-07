{ stdenv
, lib
, fetchurl
, openjdk
, unzip
, runtimeShell
, autoPatchelfHook
, openssl

# autoPatchelfHook libraries
, libusb1
, zlib
, webkitgtk
, xorg
, libjpeg
, libpng

# Configuration
, beta ? false
, sdkver
, revision
, sha256
}:

let
  binPath = lib.makeBinPath [
    openjdk
  ];
  # XXX
  # /build/.Garmin/ConnectIQ/Devices
  devicesDir = "/nix/store/eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee-TODO";
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
    openssl
  ];

  buildInputs = [
    libusb1
    zlib
    webkitgtk
    xorg.libXxf86vm
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

  postFixup = ''
    echo ":: Generating default.jungle"
    (PS4=" $ "
    set -x
    cp -r ${sdkpath}/samples/Attention tmp
    cd tmp
    openssl genrsa -out developer_key.pem 4096
    openssl pkcs8 -topk8 -inform PEM -outform DER -in developer_key.pem -out developer_key.der -nocrypt
    $out/bin/monkeyc -y developer_key.der -f monkey.jungle -o Attention.prg &>/dev/null || :
    )
    rm -rf tmp

    echo ":: Fixing-up default.jungle"
    (
    cd ${sdkpath}/bin
    substituteInPlace default.jungle \
      --replace '/build/.Garmin/ConnectIQ/Devices' "${devicesDir}"
    )
  '';

  meta = with lib; {
    description = "Connect IQ SDK";
    homepage = "https://developer.garmin.com/connect-iq-sdk/";
    license = {
      fullName = "Connect IQ License Agreement";
      url = "https://developer.garmin.com/connect-iq/license-agreement/";
      free = false;
    };
    platforms = platforms.linux;
  };
}
