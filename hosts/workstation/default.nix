# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  pkgs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "workstation"; # Define your hostname.

  time.hardwareClockInLocalTime = true;

  virtualisation.docker = {
    enable = true;
    daemon.settings.features.cdi = true;
  };
  hardware.nvidia-container-toolkit.enable = true;

  environment.systemPackages = [
    pkgs.nvtopPackages.nvidia
  ];

  services.ollama = {
    enable = true;
    package = pkgs.ollama-cuda;
    environmentVariables = {
      OLLAMA_CONTEXT_LENGTH = "48000";
    };
  };
  services.open-webui =
    let
      ollama = config.services.ollama;
    in
    {
      enable = ollama.enable;
      port = 6901;
      environment = {
        OLLAMA_BASE_URL = "http://${ollama.host}:${toString ollama.port}";
        OLLAMA_API_BASE_URL = "http://${ollama.host}:${toString ollama.port}/api";
        ENABLE_WEB_SEARCH = "true";
        WEB_SEARCH_ENGINE = "searxng";
        WEB_SEARCH_TRUST_ENV = "true";
        SEARXNG_QUERY_URL = "http://search.manta.zt/search?q=<query>";
      };
    };

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?

}
