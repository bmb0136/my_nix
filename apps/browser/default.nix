{ pkgs, lib, ... }:
{
  home-manager.sharedModules = [
    {
      home.sessionVariables = {
        NIXOS_OZONE_WL = "1";
      };
      programs.chromium = {
        enable = true;
        package = pkgs.ungoogled-chromium.override { enableWideVine = true; };
        extensions =
          let
            versions = lib.pipe ./versions.json [
              builtins.readFile
              builtins.fromJSON
            ];

            removeCommands =
              { id, path }:
              pkgs.stdenvNoCC.mkDerivation {
                name = "${id}-no-commands";
                dontUnpack = true;
                nativeBuildInputs = with pkgs; [
                  unzip
                  zip
                  jq
                ];
                buildPhase = ''
                  cp "${path}" input.zip
                  zip -FF input.zip --out temp.zip
                  unzip -p temp.zip manifest.json | jq '.commands = {}' > manifest.json
                  zip -u temp.zip manifest.json
                  mkdir -p "$out"
                  cp temp.zip "$out/extension.crx"
                '';
              };

            mkExtension =
              { id, name }:
              {
                inherit id;
                crxPath =
                  let
                    drv = removeCommands {
                      inherit id;
                      path = ./crx/${name};
                    };
                  in
                  "${drv}/extension.crx";
                version = builtins.getAttr id versions;
              };
          in
          lib.pipe ./extensions.json [
            builtins.readFile
            builtins.fromJSON
            (map mkExtension)
          ];
      };
    }
  ];
}
