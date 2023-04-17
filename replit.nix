{ pkgs, replit-overlay ? import ./nixpkgs-replit/default.nix { } } : {
  deps = [
    replit-overlay.ponysay
    (pkgs.haskellPackages.ghcWithPackages (pkgs: [
      # Put your dependencies here!
    ]))
    pkgs.haskell-language-server
  ];
}
