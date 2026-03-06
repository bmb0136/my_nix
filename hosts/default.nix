{
  inputs,
  ...
}:
{
  flake.nixosConfigurations =
    let
      mkHost = (import ./mkHost.nix) inputs;
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
