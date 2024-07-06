{ repoRoot, inputs, pkgs, lib, system }:

let

  paths = lib.unique (__filter __isString (
    lib.forEach (lib.filesystem.listFilesRecursive ../.)
      (path:
        let
          matches = __match (toString (../. + "(/.*)/src/.*")) (toString path);
        in
          if __isList matches
          then __head matches
          else null)));

  exercism-paths = lib.unique (__filter __isString (
    map
      (path:
        let
          matches = __match (toString (../. + "(/exercism/haskell/.*)/src/.*")) (toString path);
        in
          if __isList matches
          then __head matches
          else null)
      (lib.filesystem.listFilesRecursive ../.)));

  all = lib.forEach paths (path:
    {
      packages."${baseNameOf path}" = (repoRoot.nix.project { inherit path; }).flake.packages;
      devShells."${baseNameOf path}" = (repoRoot.nix.project { inherit path; }).flake.devShell;
      devShells."${baseNameOf path}-replit" = (repoRoot.nix.project { inherit path; isReplit = true; }).flake.devShell;
    });

  project = repoRoot.nix.project "/exercism/haskell/space-age";
in
all ++
[
  # (
  #   # Docs for project.flake: https://github.com/input-output-hk/iogx/blob/main/doc/api.md#mkhaskellprojectoutflake
  #   project.flake
  # )
  {
    inherit paths;
    testpkgs = pkgs;
    testroot = repoRoot;
    testproject = project;
    testiogx = inputs.iogx;
    testlib = lib;
    devShells.exercism = pkgs.mkShell {
      packages = [];
      inputsFrom = lib.forEach exercism-paths (path: (repoRoot.nix.project { inherit path; }).flake.devShell);
    };
    packages.get-exercises = pkgs.writeShellApplication {
      name = "get-exercises";
      runtimeInputs = [ pkgs.exercism pkgs.hpack ];
      text = ''
        reset="\e[0;0m"
        strong="\e[1;39m"
        red="\e[1;31m"
        if ! pushd exercism; then
          echo -e "''${strong}''${red}Error: 'nix run .#get-exercises -- <lang> <token> <force>' must be run from the base directory of the project.''${reset}"
          exit 1
        fi
        ${../exercism/get-exercises.sh} "''${1-}" "''${2-}" "''${3:+$3}";
        popd
      '';
    };
  }
]
