let
  pkgs = import ./pkgs.nix;
  inherit (pkgs) connectiq;
  inherit (pkgs.lib.attrsets) genAttrs;
  buildSample = pname:
    connectiq.mkDerivation {
      pname = "connectiq-sdk-sample-${pname}";
      src = "${connectiq.sdk}/share/connectiq-sdk/samples/${pname}";
      version = connectiq.sdk.version;
      meta = {
        license = connectiq.sdk.meta.license;
      };
    }
  ;
in
genAttrs [
  "AccelMag"
  "ActivityTracking"
  "Analog"
  "ApplicationStorage"
  "Attention"
  "BackgroundTimer"
  "Comm"
  "ConfirmationDialog"
  "Drawable"
  "Encryption"
  "FieldTimerEvents"
  "GenericChannelBurst"
  "Input"
  "JsonDataResources"
  "Keyboard"
  "MapSample"
  "Menu2Sample"
  "MenuTest"
  "MO2Display"
  "MoxyField"
  "NumberPicker"
  "ObjectStore"
  "Picker"
  "PitchCounter"
  "PositionSample"
  "Primates"
  "ProgressBar"
  "RecordSample"
  "Selectable"
  "Sensor"
  "SensorHistory"
  "SimpleDataField"
  "Strings"
  "Timer"
  "UserProfile"
  "WebRequest"
] buildSample
