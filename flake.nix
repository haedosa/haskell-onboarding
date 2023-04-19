{
  description = "Haskell onboarding flake for Haedosa Inc.";
  inputs = {
    haedosa.url = "github:haedosa/flakes";
    nixpkgs.follows = "haedosa/nixpkgs";

    # Reference for replit-nixpkgs :
    # - https://github.com/replit/nixpkgs-replit/blob/main/nix/sources.json
    # - https://github.com/replit/nixpkgs-replit/pull/72 (Updated at 221207)
    replit-nixpkgs.url = "nixpkgs/52e3e80afff4b16ccb7c52e9f0f5220552f03d04";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, replit-nixpkgs, flake-utils, ... }@inputs:
    {
      overlay = nixpkgs.lib.composeManyExtensions [
        (final: prev: {
          haskellPackages = prev.haskellPackages.extend (hfinal: hprev: {
            learn-you-a-haskell =
              hfinal.callCabal2nix "learn-you-a-haskell" ./learn-you-a-haskell
              { };
          });
        })
      ];
    } // flake-utils.lib.eachDefaultSystem (system:
      let
        local-pkgs = import nixpkgs {
          inherit system;
          overlays = [ self.overlay ];
        };
        replit-pkgs = import replit-nixpkgs {
          inherit system;
          overlays = [ self.overlay ];
        };
      in {
        devShells = {
          default = self.devShells.${system}.local;
          local = import ./shell.nix { pkgs = local-pkgs; };
          replit = import ./shell.nix {
            pkgs = replit-pkgs;
            enableReplit = true;
          };
        };
        packages = {
          default = self.packages.${system}.local;
          local = local-pkgs.haskellPackages.learn-you-a-haskell;
          replit = replit-pkgs.haskellPackages.learn-you-a-haskell;
        };
        apps = {
          default = self.apps.${system}.hello;
          hello = {
            type = "app";
            program = "${self.packages.${system}.local}/bin/hello";
          };
          first = {
            type = "app";
            program = "${self.packages.${system}.local}/bin/first";
          };
        };
      });
}

