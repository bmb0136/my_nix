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

        input = {
          mice = [
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
        };

        krunner.shortcuts.launch = "Meta+R";
        spectacle.shortcuts = {
          launch = "Meta+Shift+Print"; # Overriden from the default: Meta+R
          captureRectangularRegion = "Meta+Shift+S";
          recordRegion = "Meta+Shift+R";
        };

        panels = [
          # Taskbar
          {
            location = "bottom";
            height = 48;
            lengthMode = "fill";
            alignment = "left";
            hiding = "none";
            floating = false;
            screen = "all";
            widgets = [
              {
                kickoff = {
                  icon = "nix-snowflake-white";
                };
              }
              {
                iconTasks = {
                  launchers = [
                    "applications:org.kde.dolphin.desktop"
                    "applications:firefox.desktop"
                    "applications:org.kde.konsole.desktop"
                  ];
                };
              }
              "org.kde.plasma.marginsseparator"
              "org.kde.plasma.systemtray"
              "org.kde.plasma.digitalclock"
              "org.kde.plasma.showdesktop"
            ];
          }
        ];

        shortcuts = {
          "services/org.kde.konsole.desktop"._launch = "Meta+Return";
          "services/org.kde.plasma-systemmonitor.desktop"._launch = "Ctrl+Shift+Esc";
          "services/systemsettings.desktop"._launch = "Meta+I";
        };

        configFile = {
          kwinrc.Effect-overview.BorderActivate = 9;
          ksmserverrc.General.loginMode = "emptySession";
          spectaclerc.General.clipboardGroup = "PostScreenshotCopyImage";
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
