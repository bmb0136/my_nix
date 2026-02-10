{ config, lib, ... }:
{
  options.bmb0136.modules.app-git.enable = lib.mkEnableOption "git";

  config = lib.mkIf config.bmb0136.modules.app-git.enable {
    home-manager.sharedModules = [
      {
        programs.git = {
          enable = true;
          settings = {
            init.defaultBranch = "main";
          };
        };
      }
    ];
  };
}
