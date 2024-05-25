{ inputs ?
  let flake = builtins.getFlake (toString ./.);
  in flake.inputs
, system ? builtins.currentSystem
, overlays ? [ (import ./overlays { inherit inputs; }).default ]
}:
let
  inherit (inputs) nixpkgs;
in
import nixpkgs {
  inherit system overlays;
  config = {
    allowUnfree = true;
    allowBroken = true;

  };
}

