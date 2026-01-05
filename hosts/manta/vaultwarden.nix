{ config, lib, ... }:
{
  services.vaultwarden = {
    enable = true;
    config = {
      DOMAIN = "https://bitwarden.manta.zt";
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = "3001";
    };
  };
  services.nginx = lib.mkIf config.services.nginx.enable {
    virtualHosts."bitwarden.manta.zt" = {
      forceSSL = true;
      locations."/" = {
        proxyWebsockets = true;
        proxyPass = "http://${config.services.vaultwarden.config.ROCKET_ADDRESS}:${config.services.vaultwarden.config.ROCKET_PORT}";
        extraConfig = "client_max_body_size 512M;";
      };
      sslCertificate = ../../certs/bitwarden.pub;
      sslCertificateKey = config.sops.secrets."bitwarden/private_key".path;
    };
  };
  sops.secrets."bitwarden/private_key" = {
    mode = "0440";
    owner = config.services.nginx.user;
    group = config.services.nginx.group;
  };
}
