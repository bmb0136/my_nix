{
  config,
  lib,
  ...
}: {
  services.gitea = {
    enable = true;
    settings = {
      server.ROOT_URL = lib.mkIf config.services.nginx.enable "http://git.manta.zt/";
      service.DISABLE_REGISTRATION = true;
      repository.ENABLE_PUSH_CREATE_USER = true;
    };
  };
  services.nginx = lib.mkIf config.services.nginx.enable {
    virtualHosts."git.manta.zt" = {
      locations."/" = {
        proxyWebsockets = true;
        proxyPass = "http://127.0.0.1:3000";
        extraConfig = "client_max_body_size 512M;";
      };
    };
  };
}
