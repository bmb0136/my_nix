{ pkgs, ... }:
{
  imports = [
    ./gaming.nix
  ];

  bmb0136.modules = {
    app-alacritty.enable = true;
    app-browser.enable = true;
    app-musescore.enable = true;
    app-obsidian.enable = true;
  };

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
