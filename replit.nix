{ pkgs } : {
  deps = [
    pkgs.haskellPackages.haskell-language-server
    pkgs.exercism
    # (pkgs.haskellPackages.ghcWithPackages (pkgs: [
    #    # Put your dependencies here!
    # ]))
    # pkgs.haskellPackages.cabal-install
  ];
}
