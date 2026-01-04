{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ../theme
  ];
  home-manager.sharedModules = [
    inputs.plasma-manager.homeModules.plasma-manager
    {
      home.packages = [
        (pkgs.writeShellScriptBin "plasma-rc2nix" ''
          "${inputs.plasma-manager.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/rc2nix" "$@"
        '')
      ];

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

        powerdevil = lib.genAttrs [ "AC" "battery" "lowBattery" ] (_: {
          # Disable auto sleeping (breaks nvidia drivers)
          autoSuspend.action = "nothing";
          # Windows parity
          powerButtonAction = "shutDown";
        });

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
                    "applications:chromium-browser.desktop"
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

          # Global keybinds for Chrome to avoid popup on every rebuild
          "org.chromium.Chromium"."41529AAB007CA42346EBFC690192B4B1-addSite" = [ ];
          "org.chromium.Chromium"."41529AAB007CA42346EBFC690192B4B1-switchEngine" = [ ];
          "org.chromium.Chromium"."41529AAB007CA42346EBFC690192B4B1-toggle" = [ ];
          "org.chromium.Chromium"."5B167395AA116C916F6211AD24A9802F-enter-picker-mode" = [ ];
          "org.chromium.Chromium"."5B167395AA116C916F6211AD24A9802F-enter-zapper-mode" = [ ];
        };

        configFile = {
          kwinrc.Effect-overview.BorderActivate = 9;
          ksmserverrc.General.loginMode = "emptySession";
          spectaclerc.General.autoSaveImage = true;
          spectaclerc.General.clipboardGroup = "PostScreenshotCopyImage";
          spectaclerc.General.launchAction = "DoNotTakeScreenshot";
          spectaclerc.General.useReleaseToCapture = true;
          spectaclerc.ImageSave.translatedScreenshotsFolder = "Screenshots";
          spectaclerc.VideoSave.translatedScreencastsFolder = "Screencasts";

          # Fix alt+tab lag
          kwinrc.TabBox.HighlightWindows = false;
          kwinrc.TabBox.LayoutName = "compact";
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
