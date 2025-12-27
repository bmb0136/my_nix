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
          main,
          bundle,
          users,
        }:
        inputs.nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = (map (x: ../users/${x}) users) ++ [
            main
            ./bundles/${bundle}.nix
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
        main = ./hp-laptop;
        bundle = "laptop";
        users = [ "brandon" ];
      };
      workstation = mkHost {
        system = "x86_64-linux";
        main = ./workstation;
        bundle = "desktop";
        users = [ "brandon" ];
      };
    };
}
