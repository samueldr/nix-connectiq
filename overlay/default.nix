self: super:

{
  libjpeg8 = self.callPackage ./libjpeg {};
  connectiq = self.recurseIntoAttrs {
    sdk = self.callPackage ./sdk {
      libpng = super.libpng12;
      libjpeg = self.libjpeg8;
    };
  };
}
