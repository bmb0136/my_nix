{ pkgs, config, ... }:
{
  imports = [
    ../browser
    ../alacritty.nix
    ../obsidian
    ./gaming.nix
    ../.
    ../musescore
  ];

  environment.systemPackages = [
    pkgs.vlc
    pkgs.libreoffice
    pkgs.audacity
    pkgs.gimp
    pkgs.krita
    (pkgs.blender.override { cudaSupport = config.hardware.nvidia.enabled; })
  ];

  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.flatpak.enable = true;
}
