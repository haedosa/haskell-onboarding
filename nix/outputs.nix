{ repoRoot, inputs, pkgs, lib, system }:

let

  hPkgPaths = lib.unique (__filter __isString (
    map
      (path:
        let
          matches = __match (toString (../. + "/(.*)/src/.*")) (toString path);
        in
          if __isList matches
            # && __length matches == 1
            && ! lib.hasSuffix "hs" (__head matches)
            # && ! lib.hasSuffix "flake" (__head matches)
          then "/" + __head matches
          else null)
      (lib.filesystem.listFilesRecursive ../.)));

  project = repoRoot.nix.project "/learn-you-a-haskell";

in
lib.forEach hPkgPaths (path:
  {
    packages."${baseNameOf path}" = (repoRoot.nix.project path).flake.packages;
    devShells."${baseNameOf path}" = (repoRoot.nix.project path).flake.devShell;
  })
++
[
  # (
  #   # Docs for project.flake: https://github.com/input-output-hk/iogx/blob/main/doc/api.md#mkhaskellprojectoutflake
  #   project.flake
  # )
  {
    test = pkgs;
    testroot = repoRoot;
    testproject = project;
    packages.default = project.flake.packages;
    devShells.default = project.flake.devShell;
  }
]
