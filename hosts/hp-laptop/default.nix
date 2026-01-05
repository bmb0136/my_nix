{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "hp-laptop";

  time.hardwareClockInLocalTime = true;

  virtualisation.docker.enable = true;

  security.pki.certificateFiles = [
    ../../certs/auburn.cer
    ../../certs/usertrust.pem
  ];

  hardware = {
    bluetooth.enable = true;
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
        libva-vdpau-driver
        libvdpau-va-gl
      ];
    };
  };

  home-manager.sharedModules = [
    (lib.mkIf config.services.desktopManager.plasma6.enable {
      programs.plasma.input.touchpads = [
        {
          enable = true;
          disableWhileTyping = true;
          name = "ELAN0712:00 04F3:30FD Touchpad";
          naturalScroll = true;
          vendorId = "04f3";
          productId = "30fd";
        }
      ];
    })
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
  };

  system.stateVersion = "25.05";
}
