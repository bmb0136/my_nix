{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.bmb0136.modules.app-tmux.enable = lib.mkEnableOption "tmux";

  config = lib.mkif config.bmb0136.modules.app-tmux.enable {
    environment.systemPackages = [
      pkgs.tmux
    ];
    home-manager.sharedModules = [
      {
        programs.tmux = {
          enable = true;
          baseIndex = 1;
          escapeTime = 0;
          extraConfig = ''
            set-option -sa terminal-overrides ",xterm*:Tc"
            set -g default-terminal "xterm-256color"
          '';
        };
      }
    ];
  };
}
