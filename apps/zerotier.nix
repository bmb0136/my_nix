{ config, lib, ... }:
{
  services.zerotierone = {
    enable = true;
    joinNetworks = [ "0cccb752f7bad052" ];
  };
  networking.nameservers = [
    "192.168.194.101" # dnsmasq on manta
    "1.1.1.1"
    "9.9.9.9"
  ];
  networking.networkmanager.insertNameservers = lib.mkIf config.networking.networkmanager.enable config.networking.nameservers;
  security.pki.certificateFiles = [
    ../certs/bitwarden.pub
  ];
}
