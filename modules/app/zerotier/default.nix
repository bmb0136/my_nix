{ config, lib, ... }:
{
  options.bmb0136.modules.app-zerotier.enable = lib.mkEnableOption "zerotier";

  config = lib.mkIf config.bmb0136.modules.app-zerotier.enable {
    services.zerotierone = {
      enable = true;
      joinNetworks = [ "0cccb752f7bad052" ];
    };
    networking.extraHosts = lib.strings.join "\n" [
      "192.168.194.101 manta.zt"
      "192.168.194.101 git.manta.zt"
      "192.168.194.101 bitwarden.manta.zt"
      "192.168.194.101 files.manta.zt"
      "192.168.194.101 search.manta.zt"

      "192.168.194.100 nuc.zt"
    ];
    security.pki.certificateFiles = [
      ./bitwarden.pub
    ];
  };
}
