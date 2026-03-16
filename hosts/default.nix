{
  self,
  inputs,
  ...
}:
{
  flake = {
    nixosModules =
      let
        mkBaseModule = modules: {
          imports = modules ++ [
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
        hp-laptop = mkBaseModule [
          ./hp-laptop
          ./bundles/laptop.nix
          ../apps/bundles/coding.nix
          ../apps/zerotier.nix
        ];
        workstation = mkBaseModule [
          ./workstation
          ./bundles/desktop.nix
          ../apps/bundles/coding.nix
          ../apps/zerotier.nix
        ];
        manta = mkBaseModule [
          ./manta
          ./bundles/server.nix
        ];
      };
    nixosConfigurations =
      let
        mkHost =
          {
            system,
            base,
            users,
          }:
          inputs.nixpkgs.lib.nixosSystem {
            inherit system;
            specialArgs = { inherit inputs; };
            modules = [ base ] ++ (map (x: ../users/${x}) users);
          };
        hosts = {
          hp-laptop = {
            system = "x86_64-linux";
            users = [ "brandon" ];
          };
          workstation = {
            system = "x86_64-linux";
            users = [ "brandon" ];
          };
          manta = {
            system = "x86_64-linux";
            users = [ "jelly" ];
          };
        };
      in
      builtins.mapAttrs (
        n: v:
        mkHost {
          inherit (v) system users;
          base = self.nixosModules.${n};
        }
      ) hosts;
  };
}
