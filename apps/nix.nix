{ inputs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  nix.registry = {
    nixpkgs.flake = inputs.nixpkgs;
    my_nvim.flake = inputs.my_nvim;
  };
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };
}
