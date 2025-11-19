{ pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  networking.hostName = "hp-laptop";
  services.automatic-timezoned.enable = true;

  environment.systemPackages = with pkgs; [ brightnessctl ];

  services.libinput = {
    enable = true;
    touchpad.naturalScrolling = true;
  };

  time.hardwareClockInLocalTime = true;

  virtualisation.docker.enable = true;

  services.xserver.displayManager.setupCommands = ''
    ${pkgs.xorg.xinput}/bin/xinput disable 10
  '';

  hardware = {
    bluetooth.enable = true;
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
        vaapiVdpau
        libvdpau-va-gl
      ];
    };
  };

  system.stateVersion = "25.05";
}
