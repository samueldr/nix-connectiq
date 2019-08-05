{ stdenvNoCC, sdk }:

{ pname, version, ... } @args:

stdenvNoCC.mkDerivation ({
  inherit pname version;
  name = "${pname}-${version}";

  phases = [
    "unpackPhase"
    "patchPhase"
    "buildPhase"
    "checkPhase"
    "distPhase"
  ];

  nativeBuildInputs = [
    sdk
  ];

  buildPhase = ''
    mkdir -p $out
    monkeyc -y ${<developer_key.der>} -f monkey.jungle -o $out/${pname}.prg
  '';

} // args)
