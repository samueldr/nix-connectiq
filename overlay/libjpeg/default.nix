{ stdenv, fetchurl, lib, static ? false }:

let
  version = "8d";
in stdenv.mkDerivation {
  pname = "libjpeg";
  version = version;

  src = fetchurl {
    url = "http://www.ijg.org/files/jpegsrc.v${version}.tar.gz";
    sha256 = "sha256-/cTUwRM4rQKKfSP7U/W7k1RnE5Kmf7G1LgwypxIYkfg=";
  };

  configureFlags = lib.optional static "--enable-static --disable-shared";

  outputs = [ "out" "dev" "bin" "man" ];

  meta = with lib; {
    homepage = "http://www.ijg.org/";
    description = "A library that implements the JPEG image file format";
    license = licenses.free;
    platforms = platforms.unix;
  };
}
