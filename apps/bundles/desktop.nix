{ pkgs, ... }:
{
  imports = [
    ../browser
    ../alacritty.nix
    ../obsidian
    ./gaming.nix
    ../.
    ../musescore.nix
  ];

  environment.systemPackages = [
    pkgs.vlc
    pkgs.libreoffice
  ];

  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.flatpak.enable = true;
}
