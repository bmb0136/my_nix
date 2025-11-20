{
  config,
  inputs,
  lib,
  ...
}:
{
  flake.nixosConfigurations =
    let
      common = [
        # Home manager
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
          };
        }
        # Basic tools
        (
          { pkgs, ... }:
          {
            environment.systemPackages = with pkgs; [
              git
              tmux
            ];
          }
        )
        # Common nix settings
        {
          nix = {
            registry = lib.mapAttrs (_: v: { flake = v; }) (
              lib.filterAttrs (_: v: lib.isType "flake" v) inputs
            );
            nixPath = config.nix.registry;
            settings = {
              auto-optimize-store = true;
              experimental-features = [
                "nix-command"
                "flakes"
              ];
            };
          };
        }
      ];
    in
    {
      hp-laptop = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = common ++ [ ./hp-laptop ];
        specialArgs = { inherit inputs; };
      };
    };
}
