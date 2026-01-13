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
      "files.manta.zt" = {
        locations."/" = {
          extraConfig = ''
            root /mnt/hdd;
            autoindex on;
          '';
        };
      };
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
