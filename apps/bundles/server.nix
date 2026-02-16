{ config, ... }:
{
  imports = [
    ../.
  ];

  bmb0136.modules.app-zerotier.enable = true;

  services.openssh.enable = true;
  services.openssh.settings.GatewayPorts = "clientspecified";

  networking.firewall.allowedTCPPorts = config.services.openssh.ports;

  virtualisation.docker.enable = true;
}
