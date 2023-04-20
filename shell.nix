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
  ] ++ pkgs.lib.optionals enableReplit [
  # required dependencies
  pkgs.git
  pkgs.emacs
  pkgs.ripgrep
  # optional dependencies
  pkgs.coreutils # basic GNU utilities
  pkgs.fd
  pkgs.clang
  ];
}
