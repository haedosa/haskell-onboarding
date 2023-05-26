{ pkgs } : {
  deps = [
    pkgs.nix
    pkgs.direnv
    pkgs.gnugrep
    (pkgs.haskellPackages.ghcWithPackages (pkgs: [
        # Put your dependencies here!
    ]))
    pkgs.haskellPackages.cabal-install
    pkgs.haskellPackages.haskell-language-server
  ];
}
