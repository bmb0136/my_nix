{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ../theme
  ];
  home-manager.sharedModules = [
    inputs.plasma-manager.homeModules.plasma-manager
    {
      programs.plasma = {
        enable = true;
        overrideConfig = true;

        input.mice = [
          # Mouse for hp-laptop (the blue one)
          {
            enable = true;
            acceleration = -0.3;
            accelerationProfile = "none";
            name = "Logitech M510";
            vendorId = "046d";
            productId = "c52b";
          }
        ];

        krunner.shortcuts.launch = "Meta+R";
        spectacle.shortcuts = {
          launch = "Meta+Shift+Print"; # Overriden from the default: Meta+R
          captureRectangularRegion = "Meta+Shift+S";
          recordRegion = "Meta+Shift+R";
        };

        shortcuts = {
          "services/org.kde.console.desktop"._launch = "Meta+Return";
          "services/org.kde.plasma-systemmonitor.desktop"._launch = "Ctrl+Shift+Esc";
          "services/systemsettings.desktop"._launch = "Meta+I";
        };
      };
    }
  ];
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
