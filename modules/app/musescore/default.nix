{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.bmb0136.modules.app-musescore.enable = lib.mkEnableOption "musescore";

  config.environment.systemPackages = lib.mkIf config.bmb0136.modules.app-musescore.enable [
    pkgs.musescore
    pkgs.muse-sounds-manager
  ];
}
