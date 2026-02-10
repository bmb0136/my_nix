{ pkgs, ... }:
[
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
    settings = {
      commitMessage = "vault backup: {{date}}";
      autoCommitMessage = "vault backup: {{date}}";
      commitMessageScript = "";
      commitDateFormat = "YYYY-MM-DD HH:mm:ss";
      autoSaveInterval = 10;
      autoPushInterval = 0;
      autoPullInterval = 0;
      autoPullOnBoot = true;
      autoCommitOnlyStaged = false;
      disablePush = false;
      pullBeforePush = true;
      disablePopups = false;
      showErrorNotices = true;
      disablePopupsForNoChanges = false;
      listChangedFilesInMessageBody = false;
      showStatusBar = true;
      updateSubmodules = false;
      syncMethod = "merge";
      mergeStrategy = "none";
      customMessageOnAutoBackup = false;
      autoBackupAfterFileChange = true;
      treeStructure = false;
      refreshSourceControl = true;
      basePath = "";
      differentIntervalCommitAndPush = false;
      changedFilesInStatusBar = false;
      showedMobileNotice = true;
      refreshSourceControlTimer = 7000;
      showBranchStatusBar = true;
      setLastSaveToLastCommit = false;
      submoduleRecurseCheckout = false;
      gitDir = "";
      showFileMenu = true;
      authorInHistoryView = "hide";
      dateInHistoryView = false;
      diffStyle = "split";
      hunks = {
        showSigns = true;
        hunkCommands = true;
        statusBar = "disabled";
      };
      lineAuthor = {
        show = false;
        followMovement = "inactive";
        authorDisplay = "initials";
        showCommitHash = false;
        dateTimeFormatOptions = "date";
        dateTimeFormatCustomString = "YYYY-MM-DD HH:mm";
        dateTimeTimezone = "viewer-local";
        coloringMaxAge = "1y";
        colorNew = {
          r = 255;
          g = 150;
          b = 150;
        };
        colorOld = {
          r = 120;
          g = 160;
          b = 255;
        };
        textColorCss = "var(--text-muted)";
        ignoreWhitespace = false;
        gutterSpacingFallbackLength = 5;
        lastShownAuthorDisplay = "initials";
        lastShownDateTimeFormatOptions = "date";
      };
    };
  }
  {
    enable = true;
    pkg = pkgs.callPackage ./tag-wrangler.nix { };
  }
]
