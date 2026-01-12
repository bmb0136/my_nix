{ pkgs, ... }:
{
  home-manager.sharedModules = [
    {
      home.sessionVariables = {
        NIXOS_OZONE_WL = "1";
      };
      programs.chromium = {
        enable = true;
        package = pkgs.ungoogled-chromium.override { enableWideVine = true; };
        extensions = [
          # UBO
          {
            id = "ddkjiahejlhfcafbddmgiahcphecmpfh";
            crxPath = ./ublock.crx;
            version = "2025.1217.1755";
          }
          # Dark Reader
          {
            id = "eimadpbcbfnmbkopoojfekhnkhdbieeh";
            crxPath = ./dark_reader.crx;
            version = "4.9.118";
          }
          # Bitwarden (actually vaultwarden hosted on manta)
          {
            id = "nngceckbapebfimnlniiiahkandclblb";
            crxPath = ./bitwarden.crx;
            version = "2025.12.0";
          }
        ];
      };
    }
  ];
}
