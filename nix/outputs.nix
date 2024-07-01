{ repoRoot, inputs, pkgs, lib, system }:

let

  non-exercism-paths = lib.unique (__filter __isString (
    map
      (path:
        let
          matches = __match (toString (../. + "(/.*)/src/.*")) (toString path);
          match = __head matches;
        in
          if __isList matches
            && ! lib.hasSuffix "hs" match
            && ! __elem match exercism-paths
          then match
          else null)
      (lib.filesystem.listFilesRecursive ../.)));

  exercism-paths = lib.unique (__filter __isString (
    map
      (path:
        let
          matches = __match (toString (../. + "(/exercism/.*)/src/.*")) (toString path);
        in
          if __isList matches
            && ! lib.hasSuffix "hs" (__head matches)
          then __head matches
          else null)
      (lib.filesystem.listFilesRecursive ../.)));

  project = repoRoot.nix.project "/exercism/haskell/space-age";
  non-exercism = lib.forEach non-exercism-paths (path:
    {
      packages."${baseNameOf path}" = (repoRoot.nix.project path).flake.packages;
      devShells."${baseNameOf path}" = (repoRoot.nix.project path).flake.devShell;
    });
  exercism = lib.forEach exercism-paths (path:
    {
      packages."${baseNameOf path}" = (repoRoot.nix.exercism-project path).flake.packages;
      devShells."${baseNameOf path}" = (repoRoot.nix.exercism-project path).flake.devShell;
    });
in
non-exercism ++ exercism ++
[
  # (
  #   # Docs for project.flake: https://github.com/input-output-hk/iogx/blob/main/doc/api.md#mkhaskellprojectoutflake
  #   project.flake
  # )
  {
    inherit exercism-paths non-exercism-paths; #
    test = pkgs;
    testroot = repoRoot;
    testproject = project;
    testiogx = inputs.iogx;
    testlib = lib;
    devShells.default = pkgs.mkShell {
      packages = [];
      inputsFrom = lib.forEach non-exercism-paths (path: (repoRoot.nix.project path).flake.devShell);
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
