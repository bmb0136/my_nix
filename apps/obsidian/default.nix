{
  config,
  ...
}:
let
  nixos-config = config;
in
{
  home-manager.sharedModules = [
    (
      {
        pkgs,
        config,
        lib,
        ...
      }:
      let
        home-config = config;
      in
      {
        options.bmb0136.obsidian.enable = lib.mkEnableOption "Enable obsidian for the current user";

        config.programs.obsidian = lib.mkIf home-config.bmb0136.obsidian.enable {
          enable = true;
          defaultSettings = {
            app = import ./app.nix;
            corePlugins = import ./plugins/core.nix;
            communityPlugins = import ./plugins/community.nix { inherit pkgs; };
            hotkeys = import ./hotkeys.nix;
          };
          vaults = {
            Main = {
              enable = true;
              target = "Documents/Obsidian-Vault";
            };
            Personal = {
              enable = true;
              target = "Documents/Obsidian-Personal";
            };
          };
        };
      }
    )
  ];
}
