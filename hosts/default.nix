{ inputs, ... }:
{
  flake.nixosConfigurations =
    let
      common = [
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
          };
        }
        ({pkgs, ...}: {
          environment.systemPackages = with pkgs; [
            git
            tmux
          ];
        })
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
