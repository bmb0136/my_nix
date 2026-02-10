{
  inputs,
  config,
  lib,
  ...
}:
{
  options.bmb0136.modules.app-nix.enable = lib.mkEnableOption "nix";

  config = lib.mkIf config.bmb0136.modules.app-nix.enable {
    nixpkgs.config.allowUnfree = true;
    nix.registry.nixpkgs.flake = inputs.nixpkgs;
    nix = {
      settings = {
        auto-optimise-store = true;
        experimental-features = [
          "nix-command"
          "flakes"
        ];
      };
    };
  };
}
