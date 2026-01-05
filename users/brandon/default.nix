{ ... }:
{
  users.users.brandon = {
    isNormalUser = true;
    home = "/home/brandon";
    description = "Brandon Buckley";
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
    ];
  };
  home-manager.users.brandon =
    { ... }:
    {
      home.username = "brandon";
      home.homeDirectory = "/home/brandon";
      home.stateVersion = "25.05";
      programs.home-manager.enable = true;

      programs.git.settings.user.name = "Brandon Buckley";
      programs.git.settings.user.email = "brandonmb0136@gmail.com";

      bmb0136.q.enable = true;
      bmb0136.obsidian.enable = true;
    };
}
