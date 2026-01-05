{ ... }:
{
  users.users.jelly = {
    isNormalUser = true;
    home = "/home/jelly";
    description = "Jelly Admin";
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
    ];
  };
  home-manager.users.jelly =
    { ... }:
    {
      home.username = "jelly";
      home.homeDirectory = "/home/jelly";
      home.stateVersion = "24.05";
      programs.home-manager.enable = true;
      bmb0136.q.enable = true;
    };
}
