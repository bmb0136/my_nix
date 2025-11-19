{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ../theme
  ];
  home-manager.sharedModules = [ inputs.plasma-manager.homeModules.plasma-manager ];
  services = {
    desktopManager.plasma6 = {
      enable = true;
      enableQt5Integration = true;
    };

    displayManager = {
      sddm = {
        enable = true;
        wayland.enable = true;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    kdePackages.kcalc
    wl-clipboard
  ];
}
