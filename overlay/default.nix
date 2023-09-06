self: super:

{
  libjpeg8 = self.callPackage ./libjpeg {};
  connectiq = self.recurseIntoAttrs {
    sdk = self.callPackage ./sdk {
      libpng = super.libpng12;
      libjpeg = self.libjpeg8;
      sdkver = "6.3.0";
      revision = "2023-08-29-fc81ed416";
      sha256 = "sha256-A4rU0B9MYz5XxRLWEhqjQPyngFgH1z81O1FlLXppkkk=";
    };

    beta_sdk = self.callPackage ./sdk {
      libpng = super.libpng12;
      libjpeg = self.libjpeg8;
      sdkver = "3.1.0.Beta3";
      beta = true;
      revision = "2019-06-14-bf21fff97";
      sha256 = "1ln4w99d8j4c4l0k0f564a0yys4bnfg5kj88ihbxrps9xkx79ckj";
    };

    mkDerivation = self.callPackage ./mkderivation {
      sdk = self.connectiq.sdk;
    };
  };
}
