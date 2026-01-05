{ config, ... }:
{
  imports = [
    ../.
    ../zerotier.nix
  ];

  services.openssh.enable = true;
  services.openssh.settings.GatewayPorts = "clientspecified";

  networking.firewall.allowedTCPPorts = config.services.openssh.ports;

  virtualisation.docker.enable = true;
}
