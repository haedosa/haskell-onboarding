{ repoRoot, inputs, pkgs, system, lib }:

let

  cabalProject' = path: pkgs.haskell-nix.cabalProject' ({ pkgs, config, ... }:
    let
      # When `isCross` is `true`, it means that we are cross-compiling the project.
      # WARNING You must use the `pkgs` coming from cabalProject' for `isCross` to work.
      isCross = pkgs.stdenv.hostPlatform != pkgs.stdenv.buildPlatform;
    in
    {
      name = "my-project";

      src = pkgs.haskell-nix.cleanSourceHaskell {
        name = "${baseNameOf path}";
        src = ../. + path;
      };

      # inputMap = {
      #   "https://chap.intersectmbo.org/" = inputs.iogx.inputs.CHaP;
      # };

      compiler-nix-name = lib.mkDefault "ghc927";

      shell.withHoogle = false;

      shell.tools = {
        cabal = "latest";
        stack = "2.9.1";
        haskell-language-server = "latest";
        implicit-hie = "latest";
      };
      # Non-Haskell shell tools go here
      shell.buildInputs = with pkgs; [
        nixpkgs-fmt
      ];
      # This adds `js-unknown-ghcjs-cabal` to the shell.
      # shell.crossPlatforms = p: [p.ghcjs];

      # flake.variants.profiled = {
      #   modules = [{
      #     enableProfiling = true;
      #     enableLibraryProfiling = true;
      #   }];
      # };

      # flake.variants.ghc928 = {
      #   compiler-nix-name = "ghc928";
      # };

      # flake.variants.ghc8107 = {
      #   compiler-nix-name = "ghc8107";
      # };

      modules =
        [
          {
            #doCheck = false;
            doCoverage = false;
            doHaddock = false;
            # contentAddressed = true;
          }
          {
            packages = { };
          }
          {
            packages = { };
          }
        ];
    });


  cabalProject = path: (cabalProject' path).appendOverlays [ ];


in
path:
  # Docs for mkHaskellProject: https://github.com/input-output-hk/iogx/blob/main/doc/api.md#mkhaskellproject
  lib.iogx.mkHaskellProject {
    cabalProject = cabalProject path;

    shellArgs = repoRoot.nix.shell;

    # includeMingwW64HydraJobs = false;

    # includeProfiledHydraJobs = false;

    # readTheDocs = {
    #   enable = false;
    #   siteFolder = "doc/read-the-docs-site";
    #   sphinxToolchain = null;
    # };

    # combinedHaddock = {
    #   enable = false;
    #   prologue = "";
    #   packages = [];
    # };
  }
