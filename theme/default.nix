{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [
    inputs.stylix.nixosModules.stylix
    ./fonts.nix
  ];
  config = {

    stylix = {
      enable = true;
      image = ./keep_coding.png;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    };

    # SDDM Compat
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
