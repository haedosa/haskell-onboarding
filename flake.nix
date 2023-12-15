{
  description = "Haskell onboarding flake for Haedosa Inc.";
  inputs = {
    haedosa.url = "github:haedosa/flakes";
    nixpkgs.follows = "haedosa/nixpkgs";
    #nixpkgs.url = "nixpkgs/52e3e80afff4b16ccb7c52e9f0f5220552f03d04";
    #nixpkgs.url = "git+file:./nixpkgs?shallow=1";
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ self.overlay ];
      };
      system = "x86_64-linux";
    in
    {
      overlay = nixpkgs.lib.composeManyExtensions [
        (final: prev: {
          haskellPackages = prev.haskellPackages.extend (hfinal: hprev: {
            learn-you-a-haskell =
              hfinal.callCabal2nix "learn-you-a-haskell" ./learn-you-a-haskell
              { };
            fp-course =
              hfinal.callCabal2nix "fp-course" ./fp-course
              { };
            algorithm-design-with-haskell =
              hfinal.callCabal2nix "algorithm-design-with-haskell" ./algorithm-design-with-haskell
              { };
          });
        })
      ];

      devShells.${system} = {
        default = import ./shell.nix { inherit pkgs; };
      };

      packages.${system} = {
        default = self.packages.${system}.fp-course;
        fp-course = pkgs.haskellPackages.fp-course;
        learn-you-a-haskell = pkgs.haskellPackages.learn-you-a-haskell;
      };

      apps.${system} = {
        default = self.apps.${system}.hello;
        hello = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/hello";
        };
        first = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/first";
        };
      };
    };
}
