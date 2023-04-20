{ pkgs, enableReplit ? false }: 
# pkgs ? import ./nixpkgs-replit/default.nix { }

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

  shellHook = pkgs.lib.optionalString enableReplit ''
    if [ -z ''${BASHCHECK+x} ]
    then
      export BASHCHECK=true
      ./ghci_wrapper.sh
    fi
  '';
}
