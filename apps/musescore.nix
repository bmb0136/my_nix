{
  pkgs,
  ...
}:
{
  environment.systemPackages = [
    pkgs.musescore
    pkgs.muse-sounds-manager
  ];
}
