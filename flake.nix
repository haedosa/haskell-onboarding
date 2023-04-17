{
  description = "Haskell onboarding flake for Haedosa Inc.";
  inputs = {
    #nixpkgs = {
    #  #url = "nixpkgs/nixos-21.11";
    #  url = "github:replit/nixpkgs-replit";
    #  flake = false;
    #};
    haedosa.url = "github:haedosa/flakes";
    nixpkgs.follows = "haedosa/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = {self, nixpkgs, flake-utils, ...}@inputs: {
    overlay = nixpkgs.lib.composeManyExtensions
      [(final: prev:
        {
          haskellPackages = prev.haskellPackages.extend #prev.haskell.packages.ghc90.extend 
            (hfinal: hprev: {
              learn-you-a-haskell = hfinal.callCabal2nix "learn-you-a-haskell" ./learn-you-a-haskell {};
            });
        }
      )];
  } // flake-utils.lib.eachDefaultSystem
    (system:
    let
      pkgs = import nixpkgs { inherit system; overlays = [self.overlay]; };
    in rec {
      devShells = {
        default = pkgs.haskellPackages.shellFor {
          packages = p:[
            p.learn-you-a-haskell
          ];
          buildInputs = (import ./replit.nix { inherit pkgs; replit-overlay = pkgs; }).deps;
          #[
          #  pkgs.cowsay
          #  (pkgs.haskellPackages.ghcWithPackages (pkgs: [
          #    # Put your dependencies here!
          #  ]))
          #  pkgs.haskell-language-server
          #];
        };
      };
      packages = {
        default = pkgs.haskellPackages.learn-you-a-haskell;
      };
      apps = {
        default = {
          type = "app";
          program = "${packages.default}/bin/hello";
        };
        first = {
          type = "app";
          program = "${packages.default}/bin/first";
        };
      };
    }
  );
}
