{ pkgs, lib, ... }:
{
  home-manager.sharedModules = [
    {
      home.sessionVariables = {
        NIXOS_OZONE_WL = "1";
      };
      programs.chromium = {
        enable = true;
        package = pkgs.ungoogled-chromium;
        extensions =
          let
            createChromiumExtensionFor =
              browserVersion:
              {
                id,
                sha256,
                version,
              }:
              {
                inherit id;
                crxPath = builtins.fetchurl {
                  url = "https://clients2.google.com/service/update2/crx?response=redirect&acceptformat=crx2,crx3&prodversion=${browserVersion}&x=id%3D${id}%26installsource%3Dondemand%26uc";
                  name = "${id}.crx";
                  inherit sha256;
                };
                inherit version;
              };
            createChromiumExtension = createChromiumExtensionFor (
              lib.versions.major pkgs.ungoogled-chromium.version
            );
          in
          map createChromiumExtension [
            # UBO
            {
              id = "ddkjiahejlhfcafbddmgiahcphecmpfh";
              sha256 = "sha256:0swqw3siwgpvqvqb1hrmibs2snpl10sdhy7qdc8xja87qyjjmwqz";
              version = "2025.1217.1755";
            }
            # Dark Reader
            {
              id = "eimadpbcbfnmbkopoojfekhnkhdbieeh";
              sha256 = "sha256:0hijj2gd34qqspxx9y7kjdya5q9kdjl4lajc6mgh7jysziw0c838";
              version = "4.9.118";
            }
          ];
      };
    }
  ];
}
