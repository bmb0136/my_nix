{ ... }:
{
  imports = [
    ../../theme
  ];

  programs.ssh.startAgent = true;

  networking.networkmanager.enable = true;
}
