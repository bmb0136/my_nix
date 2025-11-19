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

      programs.git.userName = "Brandon Buckley";
      programs.git.userEmail = "brandonmb0136@gmail.com";
    };
}
