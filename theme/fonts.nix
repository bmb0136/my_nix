{ pkgs, config, ... }:
{
  config = {
    stylix.fonts = {
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
    fonts.fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ config.stylix.fonts.monospace.name ];
        emoji = [ config.stylix.fonts.emoji.name ];
      };
    };
  };
}
