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
        extensions = lib.pipe ./extensions.json [
          builtins.readFile
          builtins.fromJSON
          (map (
            { id, name }:
            {
              inherit id;
              crxPath = ./crx/${name}.crx;
              version = "0.0.0.0";
            }
          ))
        ];
      };
    }
  ];
}
