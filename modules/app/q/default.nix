{ config, lib, ... }:
{
  options.bmb0136.modules.app-q.enable = lib.mkEnableOption "q";

  config = lib.mkIf config.bmb0136.modules.app-q.enable {
    home-manager.sharedModules = [
      (
        {
          config,
          pkgs,
          lib,
          ...
        }:
        {
          options.bmb0136.q.enable = lib.mkEnableOption "Enable the 'q' tool for the current user";

          config.home.packages = lib.optionals config.bmb0136.q.enable [
            (pkgs.writeShellApplication {
              name = "q";
              runtimeInputs = with pkgs; [
                fzf
                openssh
                git
              ];
              text = builtins.readFile ./main.sh;
            })
          ];
        }
      )
    ];
  };
}
