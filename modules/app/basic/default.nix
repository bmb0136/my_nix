{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.bmb0136.modules.app-basic.enable = lib.mkEnableOption "basic";

  config = lib.mkIf config.bmb0136.modules.app-basic.enable {
    environment.shellAliases = {
      l = "ls -lah";
      ll = "ls -l";
      ls = "ls --color=tty";
      cls = "clear";
      grep = "grep --color=auto";
    };

    bmb0136.modules.app-git.enable = true;

    environment.systemPackages = with pkgs; [
      btop
      htop
      wget
      curl
      fzf
      traceroute
      file
      unzip
      fastfetch
    ];
  };
}
