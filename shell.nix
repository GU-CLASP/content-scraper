with (import <nixpkgs> {}).pkgs;
let hp = pkgs.recurseIntoAttrs(haskellPackages.override{
        overrides = self: super:
        let callPackage = self.callPackage; in {
            encoding = callPackage ./encoding.nix {};
        };
       });

in
    stdenv.mkDerivation {
    name = "scraper-arabic";

   
    buildInputs =
       [(hp.ghcWithPackages (hs: with hs; [
         scalpel encoding
       ]))];
    shellHook = ''
      export LANG=en_US.UTF-8
      '';
     }
