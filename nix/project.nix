{ repoRoot, inputs, pkgs, system, lib }:

{ path, isReplit ? false }:
let
  l = builtins // lib;

  isExercism = __match "/exercism/haskell/.*" path != null;


  project' = path: pkgs.haskell-nix.project' ({ pkgs, config, ... }:
    let
      # When `isCross` is `true`, it means that we are cross-compiling the project.
      # WARNING You must use the `pkgs` coming from project' for `isCross` to work.
      isCross = pkgs.stdenv.hostPlatform != pkgs.stdenv.buildPlatform;
      stack-wrapped = pkgs.symlinkJoin {
        name = "stack"; # will be available as the usual `stack` in terminal
        paths = [ (pkgs.haskell-nix.tool "ghc965" "stack" "2.13.1") ];
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/stack \
            --add-flags "\
              --no-nix \
              --system-ghc \
              --no-install-ghc \
            "
        '';
      };
    in
    {

      name = "${baseNameOf path}";

      src = pkgs.haskell-nix.cleanSourceHaskell {
        name = "${baseNameOf path}";
        src = ../. + path;
      };

      projectFileName = "cabal.project";
      ignorePackageYaml = true;

      # inputMap = {
      #   "https://chap.intersectmbo.org/" = inputs.iogx.inputs.CHaP;
      # };

      compiler-nix-name =
        l.optionalString isExercism "ghc92"
        +
        l.optionalString (!isExercism) "ghc98"
      ;

      shell.withHoogle = false;

      shell.tools =
        l.optionalAttrs (!isReplit) {
          cabal = "latest";
          haskell-language-server = "latest";
          implicit-hie = "latest";
        }
        //
        l.optionalAttrs isReplit {
          cabal = "latest";
        }
      ;

      # Non-Haskell shell tools go here
      shell.buildInputs = with pkgs;
        l.optionals (!isReplit) [
          # stack-wrapped
          nixpkgs-fmt
        ]
        ++
        l.optionals isReplit []
      ;

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


  # project = path: (project' path).appendOverlays [ ];


in
  # Docs for mkHaskellProject: https://github.com/input-output-hk/iogx/blob/main/doc/api.md#mkhaskellproject
  lib.iogx.mkHaskellProject {
    cabalProject = project' path;

    shellArgs = repoRoot.nix.shell isReplit;

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