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

          (pkgs.writeTextDir "share/applications/dmenu.desktop" ''
            [Desktop Entry]
            Name=Dmenu
            Comment=Open dmenu
            Exec=${pkgs.dmenu-wayland}/bin/dmenu-wl_run
            Icon=utilities-terminal
            Terminal=false
            Type=Application
            Categories=Utility;Application;
          '')

          (pkgs.writeShellScriptBin "log-out" ''
            qdbus org.kde.LogoutPrompt /LogoutPrompt promptLogout
          '')
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
                      "applications:discord.desktop"
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
            "services/dmenu.desktop"._launch = "Meta+R";

            "org.chromium.Chromium"."21E2625B47EFC58175349BC83990592B-addSite" = [ ];
            "org.chromium.Chromium"."21E2625B47EFC58175349BC83990592B-switchEngine" = [ ];
            "org.chromium.Chromium"."21E2625B47EFC58175349BC83990592B-toggle" = [ ];
            "org.chromium.Chromium"."344C4667BF97B387EAC98753E9DCD034-autofill_card" = [ ];
            "org.chromium.Chromium"."344C4667BF97B387EAC98753E9DCD034-autofill_identity" = [ ];
            "org.chromium.Chromium"."344C4667BF97B387EAC98753E9DCD034-autofill_login" = [ ];
            "org.chromium.Chromium"."344C4667BF97B387EAC98753E9DCD034-generate_password" = [ ];
            "org.chromium.Chromium"."344C4667BF97B387EAC98753E9DCD034-lock_vault" = [ ];
            "org.chromium.Chromium"."91A2BBF26EA1891DCF931C050AFA9D02-enter-picker-mode" = [ ];
            "org.chromium.Chromium"."91A2BBF26EA1891DCF931C050AFA9D02-enter-zapper-mode" = [ ];
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

            # Default terminal
            kdeglobals.General.TerminalApplication = "alacritty";
            kdeglobals.General.TerminalService = "Alacritty.desktop";

            # Disabled in favor of dmenu
            krunnerrc.General.ActivateWhenTypingOnDesktop = false;

            # Power settings
            powerdevilrc."AC/Performance".PowerProfile = "performance";
            powerdevilrc."Battery/Performance".PowerProfile = "balanced";
            powerdevilrc."LoweBattery/Performance".PowerProfile = "power-saver";
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
