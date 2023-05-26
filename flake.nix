{
  description = "Haskell onboarding flake for Haedosa Inc.";
  inputs = {
    haedosa.url = "github:haedosa/flakes";
    nixpkgs.follows = "haedosa/nixpkgs";

    # Reference for replit-nixpkgs :
    # - https://github.com/replit/nixpkgs-replit/blob/main/nix/sources.json
    # - https://github.com/replit/nixpkgs-replit/pull/72
    # - https://github.com/NixOS/nixpkgs/commits/nixos-22.11?after=99fe1b870522d6ee3e692c2b6e663d6868a3fde4+3604&branch=nixos-22.11&qualified_name=refs%2Fheads%2Fnixos-22.11
    #   - Merge pull request #204428 from NixOS/backport-204350-to-release-22.11 (221206)
    replit-nixpkgs.url = "path:custom_path";
    #replit-nixpkgs.url = "nixpkgs/52e3e80afff4b16ccb7c52e9f0f5220552f03d04";
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
