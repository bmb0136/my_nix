{ ... }:
{
  users.users.gaming = {
    isNormalUser = true;
    home = "/home/gaming";
    description = "Gaming";
  };
  home-manager.users.gaming =
    { pkgs, ... }:
    {
      home.username = "gaming";
      home.homeDirectory = "/home/gaming";
      home.stateVersion = "26.05";
      programs.home-manager.enable = true;

      home.packages = [
        pkgs.prismlauncher
      ];

      programs.vesktop.enable = true;
    };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };
}
