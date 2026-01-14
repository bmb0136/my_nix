{ pkgs, ... }:
{
  imports = [
    ../browser
    ../alacritty.nix
    ../obsidian
    ./gaming.nix
    ../.
  ];

  environment.systemPackages = [
    pkgs.vlc
  ];
}
