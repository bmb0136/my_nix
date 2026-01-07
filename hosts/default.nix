{
  inputs,
  ...
}:
{
  flake.nixosConfigurations =
    let
      mkHost =
        {
          system,
          modules,
          users,
        }:
        inputs.nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules =
            modules
            ++ (map (x: ../users/${x}) users)
            ++ [
              inputs.sops-nix.nixosModules.sops
              inputs.home-manager.nixosModules.home-manager
              {
                home-manager = {
                  backupFileExtension = "bak";
                  overwriteBackup = true;
                  useGlobalPkgs = true;
                  useUserPackages = true;
                };
              }
            ];
        };
    in
    {
      hp-laptop = mkHost {
        system = "x86_64-linux";
        modules = [
          ./hp-laptop
          ./bundles/laptop.nix
          ../apps/bundles/coding.nix
          ../apps/zerotier.nix
        ];
        users = [ "brandon" ];
      };
      workstation = mkHost {
        system = "x86_64-linux";
        modules = [
          ./workstation
          ./bundles/desktop.nix
          ../apps/bundles/coding.nix
          ../apps/zerotier.nix
        ];
        users = [ "brandon" ];
      };
      manta = mkHost {
        system = "x86_64-linux";
        modules = [
          ./manta
          ./bundles/server.nix
        ];
        users = [ "jelly" ];
      };
    };
}
