{ ... }: {
  services.dnsmasq = {
    enable = true;
    settings = {
      interface = [ "ztly5q3avf" "lo" "wlo1" ];
      bind-interfaces = true;
      server = [
        "1.1.1.1"
        "9.9.9.9"
      ];
      address = [
        "/manta.zt/192.168.194.101"
        "/nuc.zt/192.168.194.100"
      ];
    };
  };
}
