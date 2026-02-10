{
  config,
  pkgs,
  lib,
  ...
}:
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
  options.bmb0136.modules.app-browser.enable = lib.mkEnableOption "browser";

  config = lib.mkIf config.bmb0136.modules.app-browser.enable {
    programs.chromium = {
      enable = true;
      enablePlasmaBrowserIntegration = config.services.desktopManager.plasma6.enable;
      extraOpts = {
        ExtensionSettings = lib.genAttrs extensionIds (id: {
          toolbar_pin = "force_pinned";
        });
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
              commandLineArgs = "--disable-features=GlobalShortcutsPortal";
            })
          );
        };
      }
    ];
  };
}
