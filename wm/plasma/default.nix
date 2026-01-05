{
  inputs,
  config,
  pkgs,
  lib,
  ...
}:
let
  nixos-config = config;
in
{
  home-manager.sharedModules = [
    inputs.plasma-manager.homeModules.plasma-manager
    (
      { config, ... }:
      let
        home-config = config;
      in
      {
        home.packages = [
          (pkgs.writeShellScriptBin "plasma-rc2nix" ''
            "${inputs.plasma-manager.packages.${pkgs.stdenv.hostPlatform.system}.default}/bin/rc2nix" "$@"
          '')

          pkgs.dmenu-wayland
        ];

        programs.plasma = {
          enable = true;
          overrideConfig = true;

          # Stylix compat
          fonts = {
            general = {
              family = nixos-config.stylix.fonts.sansSerif.name;
              pointSize = 10;
            };
            small = {
              family = nixos-config.stylix.fonts.sansSerif.name;
              pointSize = 8;
            };
            toolbar = {
              family = nixos-config.stylix.fonts.sansSerif.name;
              pointSize = 10;
            };
            menu = {
              family = nixos-config.stylix.fonts.sansSerif.name;
              pointSize = 10;
            };
            windowTitle = {
              family = nixos-config.stylix.fonts.sansSerif.name;
              pointSize = 10;
            };
            fixedWidth = {
              family = nixos-config.stylix.fonts.monospace.name;
              pointSize = 10;
            };
          };

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
              # Mouse for workstation (the gray one)
              {
                enable = true;
                acceleration = 0.4;
                accelerationProfile = "none";
                name = "Logitech M720 Triathlon";
                vendorId = "046d";
                productId = "405e";
              }
            ];
          };

          krunner.shortcuts.launch = "";
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
                      "applications:Alacritty.desktop"
                    ]
                    ++ lib.optionals home-config.bmb0136.obsidian.enable [
                      "applications:obsidian.desktop"
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
            "services/Alacritty.desktop"._launch = "Meta+Return";
            "services/org.kde.plasma-systemmonitor.desktop"._launch = "Ctrl+Shift+Esc";
            "services/systemsettings.desktop"._launch = "Meta+I";
            "services/net.local.dmenu-wl_run.desktop"._launch = "Meta+R";

            # Global keybinds for Chrome to avoid popup on every rebuild
            "org.chromium.Chromium"."41529AAB007CA42346EBFC690192B4B1-addSite" = [ ];
            "org.chromium.Chromium"."41529AAB007CA42346EBFC690192B4B1-switchEngine" = [ ];
            "org.chromium.Chromium"."41529AAB007CA42346EBFC690192B4B1-toggle" = [ ];
            "org.chromium.Chromium"."5B167395AA116C916F6211AD24A9802F-enter-picker-mode" = [ ];
            "org.chromium.Chromium"."5B167395AA116C916F6211AD24A9802F-enter-zapper-mode" = [ ];
            "org.chromium.Chromium".CAA3DEE4BDD06AA9FAB6CC4FE6EF1ABB-autofill_card = [ ];
            "org.chromium.Chromium".CAA3DEE4BDD06AA9FAB6CC4FE6EF1ABB-autofill_identity = [ ];
            "org.chromium.Chromium".CAA3DEE4BDD06AA9FAB6CC4FE6EF1ABB-autofill_login = [ ];
            "org.chromium.Chromium".CAA3DEE4BDD06AA9FAB6CC4FE6EF1ABB-generate_password = [ ];
            "org.chromium.Chromium".CAA3DEE4BDD06AA9FAB6CC4FE6EF1ABB-lock_vault = [ ];
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

            kwinrc.Windows.Placement = "Maximizing";

            # Fix alt+tab lag
            kwinrc.TabBox.HighlightWindows = false;
            kwinrc.TabBox.LayoutName = "compact";

            # Default terminal
            kdeglobals.General.TerminalApplication = "alacritty";
            kdeglobals.General.TerminalService = "Alacritty.desktop";
          };
        };
      }
    )
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
