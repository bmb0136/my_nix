{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    home-manager = {
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } (
      { ... }:
      {
        systems = [ "x86_64-linux" ];

        imports = [
          inputs.treefmt-nix.flakeModule
          ./hosts
        ];

        perSystem =
          { ... }:
          {
            treefmt = import ./treefmt.nix;
          };
      }
    );
}
