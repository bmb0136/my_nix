{ ... }:
{
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    virtualHosts."manta.zt" = {
      default = true;
      locations."/".return = "404";
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
