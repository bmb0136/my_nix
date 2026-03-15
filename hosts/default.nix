{
  self,
  inputs,
  ...
}:
{
  flake = {
    nixosModules =
      let
        mkBaseModule =
          {
            modules,
            users,
          }:
          {
            imports =
              modules
              ++ (map (x: ../users/${x}) users)
              ++ [
                ./bundles/default.nix
                ../apps/default.nix
                inputs.sops-nix.nixosModules.sops
                (
                  { pkgs, ... }:
                  {
                    environment.systemPackages = [ pkgs.sops ];
                  }
                )
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
        hp-laptop = mkBaseModule {
          modules = [
            ./hp-laptop
            ./bundles/laptop.nix
            ../apps/bundles/coding.nix
            ../apps/zerotier.nix
          ];
          users = [ "brandon" ];
        };
        workstation = mkBaseModule {
          modules = [
            ./workstation
            ./bundles/desktop.nix
            ../apps/bundles/coding.nix
            ../apps/zerotier.nix
          ];
          users = [ "brandon" ];
        };
        manta = mkBaseModule {
          modules = [
            ./manta
            ./bundles/server.nix
          ];
          users = [ "jelly" ];
        };
      };
    nixosConfigurations =
      let
        mkHost =
          {
            system,
            base,
          }:
          inputs.nixpkgs.lib.nixosSystem {
            inherit system;
            specialArgs = { inherit inputs; };
            modules = [ base ];
          };
        hosts = {
          hp-laptop = "x86_64-linux";
          workstation = "x86_64-linux";
          manta = "x86_64-linux";
        };
      in
      builtins.mapAttrs (
        n: v:
        mkHost {
          system = v;
          base = self.nixosModules.${n};
        }
      ) hosts;
  };
}
