{ pkgs } : {
  deps = [
    #(pkgs.haskellPackages.ghcWithPackages (pkgs: [
        # Put your dependencies here!
    #]))
    #pkgs.haskellPackages.cabal-install
    pkgs.haskellPackages.haskell-language-server
  ];
}
