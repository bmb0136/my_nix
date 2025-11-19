{
  inputs,
  pkgs,
  lib,
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
      };
    };
    home-manager.sharedModules = [
      {
        programs.alacritty.settings.font.size = lib.mkForce 10;
      }
    ];
  };
}
