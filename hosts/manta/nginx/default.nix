{ ... }:
{
  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts = {
      "manta.zt" = {
        default = true;
        locations."/".return = "404";
      };
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
