{ lib, ... }:
{
  services.zerotierone = {
    enable = true;
    joinNetworks = [ "0cccb752f7bad052" ];
  };
  networking.extraHosts = lib.strings.join "\n" [
    "192.168.194.101 manta.zt"
    "192.168.194.101 git.manta.zt"

    "192.168.194.100 nuc.zt"
  ];
}
