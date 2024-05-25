{
  description = "Haskell onboarding flake for Haedosa Inc.";
  inputs = {
    # haedosa.url = "github:haedosa/flakes";
    # nixpkgs.follows = "haedosa/nixpkgs";
    haskellNix.url = "github:input-output-hk/haskell.nix";
    nixpkgs.follows = "haskellNix/nixpkgs-unstable";
    #nixpkgs.url = "nixpkgs/52e3e80afff4b16ccb7c52e9f0f5220552f03d04";
    #nixpkgs.url = "git+file:./nixpkgs?shallow=1";
  };

  outputs = { self, nixpkgs, haskellNix }@inputs:
    let
      hPkgPaths = with nixpkgs.lib; unique (__filter __isString (
        map
          (path:
            let
              matches = __match (toString (./. + "/(.*)/src/.*")) (toString path);
            in
              if __isList matches
                # && __length matches == 1
                && ! hasSuffix "hs" (__head matches)
                # && ! lib.hasSuffix "flake" (__head matches)
              then "/" + __head matches
              else null)
          (filesystem.listFilesRecursive ./.)));
      hPkgNames = map baseNameOf hPkgPaths;
      mkProject = final: path: {
        "${baseNameOf path}" = final.haskell-nix.project {
          # src = ./. + path;
          src = final.haskell-nix.cleanSourceHaskell {
            name = "${baseNameOf path}";
            src = ./. + path;
          };
          modules = [
            { #doCheck = false;
              doCoverage = false;
              doHaddock = false;
              contentAddressed = true;
            }
          ];
          compiler-nix-name = "ghc927"; # lts-20.18
          # This is used by `nix develop .` to open a shell for use with
          # `cabal`, `hlint` and `haskell-language-server`
          shell.tools = {
            cabal = {};
            # hlint = {};
            haskell-language-server = {};
          };
          # Non-Haskell shell tools go here
          shell.buildInputs = with final.pkgs; [
            nixpkgs-fmt
          ];
          # This adds `js-unknown-ghcjs-cabal` to the shell.
          # shell.crossPlatforms = p: [p.ghcjs];
        };
      };
      mkProjectShell = project: project.shellFor {
        packages = ps: with ps; [
          pkga
          pkgb
        ];

        # Builds a Hoogle documentation index of all dependencies,
        # and provides a "hoogle" command to search the index.
        withHoogle = true;

        # Some common tools can be added with the `tools` argument
        tools = {
          cabal = "3.2.0.0";
          hlint = "latest"; # Selects the latest version in the hackage.nix snapshot
          haskell-language-server = "latest";
        };
        # See overlays/tools.nix for more details

        # Some you may need to get some other way.
        buildInputs = [ (import <nixpkgs> {}).git ];

        # Sellect cross compilers to include.
        crossPlatforms = ps: with ps; [
          ghcjs      # Adds support for `js-unknown-ghcjs-cabal build` in the shell
          # mingwW64 # Adds support for `x86_64-W64-mingw32-cabal build` in the shell
        ];

        # Prevents cabal from choosing alternate plans, so that
        # *all* dependencies are provided by Nix.
        exactDeps = true;
      };
      overlays = [
        haskellNix.overlay
        (final: prev: {
          # hello = final.mkProject "hello-world";
          # haskellPackages = prev.haskellPackages.extend (hfinal: hprev: {
          #   learn-you-a-haskell =
          #     hfinal.callCabal2nix "learn-you-a-haskell" ./learn-you-a-haskell
          #     { };
          #   fp-course =
          #     hfinal.callCabal2nix "fp-course" ./fp-course
          #     { };
          #   algorithm-design-with-haskell =
          #     hfinal.callCabal2nix "algorithm-design-with-haskell" ./algorithm-design-with-haskell
          #     { };
          # });
        } // __foldl' (acc: p: acc // mkProject final p) {} hPkgPaths)
      ];
      pkgs = import nixpkgs {
        inherit system overlays; inherit (haskellNix) config;
      };
      system = "x86_64-linux";
    in
    {
      #devShells.${system} = {
        #default = import ./shell.nix { inherit pkgs; };
      #};

      # test = __foldl' (acc: p: acc // { ${p} = (pkgs.${p}); }) {} hPkgNames;
      test = __foldl' (acc: p: acc // pkgs.${p}.flake'.packages) {} hPkgNames;
      packages.${system} = __foldl' (acc: p: acc // pkgs.${p}.flake'.packages) {} hPkgNames;
      # packages.${system} = {
      #   default = self.packages.${system}.fp-course;
      #   fp-course = pkgs.haskellPackages.fp-course;
      #   learn-you-a-haskell = pkgs.haskellPackages.learn-you-a-haskell;
      # };

      apps.${system} = {
        #default = self.apps.${system}.hello;
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
  # --- Flake Local Nix Configuration ----------------------------
  nixConfig = {
    # This sets the flake to use the IOG nix cache.
    # Nix should ask for permission before using it,
    # but remove it here if you do not want it to.
    extra-substituters = ["https://cache.iog.io"];
    extra-trusted-public-keys = ["hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="];
    allow-import-from-derivation = "true";
  };
}
