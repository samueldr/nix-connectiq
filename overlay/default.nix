self: super:

{
  libjpeg8 = self.callPackage ./libjpeg {};
  connectiq = self.recurseIntoAttrs {
    sdk = self.callPackage ./sdk {
      libpng = super.libpng12;
      libjpeg = self.libjpeg8;
      sdkver = "3.0.12";
      revision = "2019-06-12-77ed6f47e";
      sha256 = "0pc1vgfm3gdw0bc06602k78q658r4x9144nvaidqnagn7iaq9b86";
    };
  };
}
