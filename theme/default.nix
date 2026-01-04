{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [ inputs.stylix.nixosModules.stylix ];
  config = {
    stylix = {
      enable = true;
      image = ./keep_coding.png;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
      fonts = {
        monospace = {
          package = pkgs.nerd-fonts.jetbrains-mono;
          name = "JetBrainsMono Nerd Font";
        };
        emoji = {
          name = "Twitter Color Emoji";
          package = pkgs.symlinkJoin {
            name = "twemoji";
            paths = with pkgs; [
              twemoji-color-font
              twitter-color-emoji
            ];
          };
        };
      };
    };
    home-manager.sharedModules = [
      {
        programs.alacritty.settings.font.size = lib.mkForce 10;
      }
    ];
    services.displayManager.sddm = lib.mkIf config.services.displayManager.sddm.enable {
      theme = "breeze";
    };
    environment.systemPackages = lib.mkIf config.services.displayManager.sddm.enable [
      (pkgs.writeTextDir "share/sddm/themes/${config.services.displayManager.sddm.theme}/theme.conf.user" ''
        [General]
        background=${pkgs.runCommand "background-image" { } "cp ${./nixos.png} $out"}
      '')
    ];
  };
}
