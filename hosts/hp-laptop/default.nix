{
  pkgs,
  config,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../bundles/laptop.nix
  ];

  networking.hostName = "hp-laptop";
  services.automatic-timezoned.enable = true;

  environment.systemPackages = with pkgs; [ brightnessctl ];

  services.libinput = {
    enable = true;
    touchpad.naturalScrolling = true;
    mouse.accelProfile = "flat";
    touchpad.accelProfile = "flat";
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
        libva-vdpau-driver
        libvdpau-va-gl
      ];
    };
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;

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

  programs.ssh.startAgent = true;

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  system.stateVersion = "25.05";
}
