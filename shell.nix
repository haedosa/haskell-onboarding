{ pkgs }:

pkgs.haskellPackages.shellFor {
  packages = p: [ p.learn-you-a-haskell ];

  buildInputs = [
    (pkgs.haskellPackages.ghcWithPackages (pkgs:
      [
        # Put your dependencies here!
      ]))
    pkgs.haskellPackages.haskell-language-server
    pkgs.haskellPackages.cabal-install
  ];
}
