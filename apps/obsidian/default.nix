{
  config,
  ...
}:
let
  nixos-config = config;
in
{
  home-manager.sharedModules = [
    (
      {
        pkgs,
        config,
        lib,
        ...
      }:
      let
        home-config = config;
      in
      {
        options.bmb0136.obsidian.enable = lib.mkEnableOption "Enable obsidian for the current user";

        config.programs.obsidian = lib.mkIf home-config.bmb0136.obsidian.enable {
          enable = true;
          defaultSettings = {
            app = {
              livePreview = true;
              alwaysUpdateLinks = true;
              pdfExportSettings = {
                includeName = true;
                pageSize = "Letter";
                landscape = false;
                margin = "0";
                downscalePercent = 50;
              };
              readableLineLength = false;
              vimMode = true;
              newFileLocation = "current";
              attachmentFolderPath = "./Assets";
            };
            corePlugins = [
              {
                name = "audio-recorder";
                enable = true;
              }
              {
                name = "backlink";
                enable = true;
                settings = {
                  backlinkInDocument = false;
                };
              }
              {
                name = "bookmarks";
                enable = true;
              }
              {
                name = "canvas";
                enable = true;
              }
              {
                name = "command-palette";
                enable = true;
                settings = {
                  pinned = [
                    "workspace:export-pdf"
                  ];
                };
              }
              {
                name = "daily-notes";
                enable = true;
              }
              {
                name = "editor-status";
                enable = true;
              }
              {
                name = "file-explorer";
                enable = true;
              }
              {
                name = "file-recovery";
                enable = true;
              }
              {
                name = "global-search";
                enable = true;
              }
              {
                name = "graph";
                enable = true;
                settings = {
                  collapse-filter = false;
                  search = "";
                  showTags = true;
                  showAttachments = true;
                  hideUnresolved = false;
                  showOrphans = true;
                  collapse-color-groups = false;
                  colorGroups = [ ];
                  collapse-display = false;
                  showArrow = false;
                  textFadeMultiplier = 0;
                  nodeSizeMultiplier = 1;
                  lineSizeMultiplier = 1;
                  collapse-forces = false;
                  centerStrength = 0.518713248970312;
                  repelStrength = 10;
                  linkStrength = 1;
                  linkDistance = 250;
                  scale = 0.08722115320151679;
                  close = true;
                };
              }
              {
                name = "markdown-importer";
                enable = false;
              }
              {
                name = "note-composer";
                enable = true;
              }
              {
                name = "outgoing-link";
                enable = true;
              }
              {
                name = "outline";
                enable = true;
              }
              {
                name = "page-preview";
                enable = true;
                settings = {
                  preview = true;
                };
              }
              {
                name = "properties";
                enable = true;
              }
              {
                name = "publish";
                enable = false;
              }
              {
                name = "random-note";
                enable = false;
              }
              {
                name = "slash-command";
                enable = false;
              }
              {
                name = "slides";
                enable = true;
              }
              {
                name = "switcher";
                enable = true;
                settings = {
                  showExistingOnly = true;
                  showAttachments = true;
                  showAllFileTypes = false;
                };
              }
              {
                name = "sync";
                enable = false;
              }
              {
                name = "tag-pane";
                enable = true;
              }
              {
                name = "templates";
                enable = true;
                settings = {
                  folder = "";
                };
              }
              {
                name = "word-count";
                enable = true;
              }
              {
                name = "workspaces";
                enable = false;
              }
              {
                name = "zk-prefixer";
                enable = false;
              }
            ];
            communityPlugins = [
              {
                enable = true;
                pkg = pkgs.callPackage ./better-export-pdf.nix { };
                settings = {
                  showTitle = true;
                  maxLevel = "6";
                  displayHeader = true;
                  displayFooter = true;
                  headerTemplate = ''<div style="width: 100vw;font-size:10px;text-align:center;"><span class="title"></span></div>'';
                  footerTemplate = ''<div style="width: 100vw;font-size:10px;text-align:center;"><span class="pageNumber"></span> / <span class="totalPages"></span></div>'';
                  printBackground = false;
                  generateTaggedPDF = false;
                  displayMetadata = false;
                  debug = false;
                  isTimestamp = false;
                  enabledCss = false;
                  prevConfig = {
                    pageSize = "A4";
                    marginType = "1";
                    showTitle = true;
                    open = true;
                    scale = 50;
                    landscape = false;
                    marginTop = "10";
                    marginBottom = "10";
                    marginLeft = "10";
                    marginRight = "10";
                    displayHeader = false;
                    displayFooter = false;
                    cssSnippet = "0";
                  };
                };
              }
              {
                enable = true;
                pkg = pkgs.callPackage ./obsidian-git.nix { };
              }
              {
                enable = true;
                pkg = pkgs.callPackage ./tag-wrangler.nix { };
              }
            ];
            hotkeys = {
              "app:go-back" = [
                {
                  modifiers = [
                    "Mod"
                    "Alt"
                  ];
                  key = "ArrowLeft";
                }
                {
                  modifiers = [
                    "Alt"
                  ];
                  key = "ArrowLeft";
                }
              ];
              "app:go-forward" = [
                {
                  modifiers = [
                    "Mod"
                    "Alt"
                  ];
                  key = "ArrowRight";
                }
                {
                  modifiers = [
                    "Alt"
                  ];
                  key = "ArrowRight";
                }
              ];
            };
          };
          vaults = {
            main = {
              enable = true;
              target = "Documents/Obsidian-Vault";
            };
          };
        };
      }
    )
  ];
}
