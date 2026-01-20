{ config, lib, ... }:
{
  services.searx = {
    enable = true;
    domain = "search.manta.zt";
    redisCreateLocally = true;
    settings.server = {
      bind_address = "127.0.0.1";
      port = "3003";
    };
    environmentFile = config.sops.secrets."searxng/env".path;
  };
  services.nginx.virtualHosts."search.manta.zt" = lib.mkIf config.services.nginx.enable {
    locations = {
      "/" = {
        proxyPass = "http://${config.services.searx.settings.server.bind_address}:${toString config.services.searx.settings.server.port}";
        extraConfig = "client_max_body_size 8192M;";
      };
    };
  };
  sops.secrets."searxng/env" = {
    mode = "0440";
    # This account name is hardcoded into nixpkgs
    owner = "searx";
    group = "searx";
  };
}
