{
  pkgs,
  ...
}:
{
  environment.systemPackages = [
    (pkgs.callPackage ./package.nix {})
    pkgs.muse-sounds-manager
  ];
}
