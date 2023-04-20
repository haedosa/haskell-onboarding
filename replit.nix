{ pkgs } : {
  deps = [
    pkgs.nix
    pkgs.direnv
    (pkgs.haskellPackages.ghcWithPackages (pkgs: [
        # Put your dependencies here!
    ]))
    pkgs.haskell-language-server
  ];
}
