{
  config,
  pkgs,
  lib,
  ...
}:
let
  server = pkgs.stdenv.mkDerivation rec {
    name = "uploader";
    nativeBuildInputs = [ pkgs.go ];

    buildPhase = ''
      go build main.go
    '';

    installPhase = ''
      mkdir "$out/bin"

      cp main "$out/bin/${name}"
    '';
  };

  addr = "127.0.0.1";
  port = 3002;
in
{
  systemd.services.uploader = lib.mkif config.services.nginx.enable {
    enable = true;
    description = "File uploader";
    wantedBy = [ "multi-user.target" ];
    after = [ "nginx.service" ];
    requires = [ "nginx.service" ];
    serviceConfig = {
      User = config.services.nginx.user;
      Group = config.services.nginx.group;
      Restart = "always";
      ExecStart = ''${server}/bin/${server.name} -addr="${addr}:${port}" -upload-dir="/mnt/hdd/uploads/"'';
    };
  };
  nginx.virtualhosts."files.manta.zt" = lib.mkif config.services.nginx.enable {
    locations = {
      "/upload" = {
        proxyPass = "http://${addr}:${port}";
        extraConfig = "client_max_body_size 8192M;";
      };
      "/" = {
        extraConfig = ''
          root /mnt/hdd;
          autoindex on;
        '';
      };
    };
  };
}
