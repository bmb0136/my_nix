{ pkgs, ... }:
{
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
}
