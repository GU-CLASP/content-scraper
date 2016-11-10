{ mkDerivation, array, base, binary, bytestring, containers
, extensible-exceptions, ghc-prim, HaXml, mtl, regex-compat, stdenv
}:
mkDerivation {
  pname = "encoding";
  version = "0.8.1";
  sha256 = "1fddj2m3xv8zfz6bmgks3ynib6hk7bzq2j3bsazr71m769a9hvyr";
  libraryHaskellDepends = [
    array base binary bytestring containers extensible-exceptions
    ghc-prim HaXml mtl regex-compat
  ];
  jailbreak = true;
  homepage = "http://code.haskell.org/encoding/";
  description = "A library for various character encodings";
  license = stdenv.lib.licenses.bsd3;
}
