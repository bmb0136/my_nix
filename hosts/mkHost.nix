inputs:
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
}
