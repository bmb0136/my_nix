{ pkgs, lib, ... }:
let
  extensions = lib.pipe ./extensions.json [
    builtins.readFile
    builtins.fromJSON
  ];

  extensionIds = map (builtins.getAttr "id") extensions;

  versions = lib.pipe ./versions.json [
    builtins.readFile
    builtins.fromJSON
  ];
in
{
  programs.chromium = {
    enable = true;
    extraOpts = {
      ExtensionSettings = lib.genAttrs extensionIds (id: {
        #installation_mode = "force_installed";
        toolbar_pin = "force_pinned";
        #update_url = "https://clients2.google.com/service/update2/crx";
      });
      #ExtensionInstallForcelist = map (x: x + ";https://clients2.google.com/service/update2/crx") extensionIds;
      MandatoryExtensionsForIncognitoNavigation = [
        # UBO
        "ddkjiahejlhfcafbddmgiahcphecmpfh"
        # Dark Reader
        "eimadpbcbfnmbkopoojfekhnkhdbieeh"
      ];
    };
  };
  environment.systemPackages = lib.pipe extensions [
    (map (
      { id, name }:
      {
        inherit id name;
        version = versions.${id};
        crxPath = ./crx/${name};
      }
    ))
    (map (
      {
        id,
        name,
        version,
        crxPath,
      }:
      pkgs.writeTextDir "share/chromium/extensions/${id}.json" (
        builtins.toJSON {
          external_crx = crxPath;
          external_version = version;
        }
      )
    ))
  ];
  home-manager.sharedModules = [
    {
      home.sessionVariables = {
        NIXOS_OZONE_WL = "1";
      };
      programs.chromium = {
        enable = true;
        package = (
          pkgs.ungoogled-chromium.override (prev: {
            enableWideVine = true;
            commandLineArgs = [
              #"--enable-logging --v=1"
            ];
          })
        );
      };
    }
  ];
}
