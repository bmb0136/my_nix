{ pkgs, ... }: {
  environment.systemPackages = [ pkgs.git ];

  home-manager.sharedModules = [
    {
      programs.git = {
        enable = true;
        settings = {
          init.defaultBranch = "main";
        };
      };
    }
  ];
}
