{ pkgs, ... }:
{
  imports = [
    ./desktop.nix
  ];

  services.automatic-timezoned.enable = true;

  environment.systemPackages = with pkgs; [ brightnessctl ];

  services.libinput = {
    enable = true;
    touchpad.naturalScrolling = true;
    mouse.accelProfile = "flat";
    touchpad.accelProfile = "flat";
  };

}
