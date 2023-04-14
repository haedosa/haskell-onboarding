{
  description = "Haskell onboarding flake for Haedosa Inc.";
  inputs = {
    haedosa.url = "github:haedosa/flakes";
    nixpkgs.follows = "haedosa/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {self, nixpkgs, flake-utils, ...}@inputs: {
    overlay = nixpkgs.lib.composeManyExtensions
      [(final: prev:
        {
          haskellPackages = prev.haskellPackages.extend
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
          buildInputs = (import ./replit.nix { inherit pkgs; }).deps;
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
