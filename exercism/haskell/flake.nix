{
  description = "exercism";

  inputs = {

    # For infrastructure
    haedosa.url = "github:haedosa/flakes";
    nixpkgs.follows = "haedosa/nixpkgs-23-05";
    flake-utils.url = "github:numtide/flake-utils";

    # For deployment
    home-manager.follows = "haedosa/home-manager-23-05";
    deploy-rs = {
      url ="github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # For development
    hmatrix.url = "github:haedosa/hmatrix/haedosa";
    hutils.url = "git+ssh://git@github.com/haedosa/hutils";
    fitdosa.url = "git+ssh://git@github.com/haedosa/fitdosa";
    mldosa.url = "git+ssh://git@github.com/haedosa/mldosa?ref=layernet-typed";
    hserver.url = "git+ssh://git@github.com/haedosa/hserver.git";
    typelits-witnesses.url = "github:haedosa/typelits-witnesses";
    typelits-witnesses.flake = false;
    # aeson.url = "github:haskell/aeson/1.5.6.0";
    # aeson.flake = false;
    # reanimate-svg.url = "github:reanimate/reanimate-svg/v0.13.0.0";
    # reanimate-svg.url = "github:reanimate/reanimate-svg/v0.12.2.2";
    reanimate.url = "github:reanimate/reanimate";
    reanimate.flake = false;
    reanimate-svg.url = "github:reanimate/reanimate-svg";
    reanimate-svg.flake = false;

    hasktorch.url = "github:haedosa/hasktorch?ref=vanilla-nix";
    accelerate.url = "github:AccelerateHS/accelerate";
    accelerate.flake = false;
    accelerate-llvm.url = "github:AccelerateHS/accelerate-llvm";
    accelerate-llvm.flake = false;
    llvm-hs.url = "github:llvm-hs/llvm-hs?ref=llvm-15";
    llvm-hs.flake = false;
    cuda.url = "github:tmcdonell/cuda";
    cuda.flake = false;
    nvvm.url = "github:tmcdonell/nvvm";
    nvvm.flake = false;

  };

  outputs = inputs@{ self, nixpkgs, flake-utils, ... }:
    let
      system = "x86_64-linux";
      pkgs = import ./pkgs.nix {
        inherit inputs system;
      };

      inherit (import ./lib.nix { inherit inputs pkgs; })
        mk-evaluation-script
        mk-run-many-scripts
      ;

      evaluations = import ./evaluations { inherit inputs pkgs; };

      run-evaluations = (pkgs.lib.mapAttrs' (name: value: let exe = "run-${name}"; in {
          name = exe;
          value = mk-evaluation-script exe value;
        }) evaluations);


      run-all-evaluations = mk-run-many-scripts
        (pkgs.lib.mapAttrsToList (name: value: {
          pkg = value;
          exe = name;
        }) run-evaluations);

      experiments = import ./experiments { inherit inputs pkgs; };

    in
    {
      inherit pkgs experiments;

      overlays = import ./overlays { inherit inputs; };

      deploy = import ./deploy.nix {
        inherit pkgs;
        inherit (self.packages.${system}) fmmdosa-serve;
        inherit (inputs) home-manager deploy-rs;
      };

    }
    // flake-utils.lib.eachSystem [ system ] (system:
    {
      inherit pkgs;
      devShells = {
        default = import ./develop.nix {
          inherit pkgs;
        };
      };

      packages = import ./packages.nix {
        inherit system pkgs;
      };

      apps.test = import ./apps { inherit inputs pkgs run-evaluations experiments; };

      apps.default = {
        type = "app";
        program = "${pkgs.fmmdosa-cli}/bin/fmmdosa-cli";
      };

    });
}

