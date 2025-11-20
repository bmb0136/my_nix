{
  inputs,
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
            backupFileExtension = "bak";
            overwriteBackup = true;
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
            settings = {
              auto-optimise-store = true;
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
