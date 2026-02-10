{ config, lib, ... }:
{
  options.bmb0136.modules.app-alacritty.enable = lib.mkEnableOption "alacritty";

  config.home-manager.sharedModules = lib.mkIf config.bmb0136.modules.app-alacritty.enable [
    {
      programs.alacritty = {
        enable = true;
        settings = {
          window.startup_mode = "Maximized";
        };
      };
    }
  ];
}
