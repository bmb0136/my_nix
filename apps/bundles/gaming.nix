{
  programs.steam.enable = true;
  home-manager.sharedModules = [
    (
      { pkgs, ... }:
      {
        home.packages = [
          pkgs.prismlauncher
          pkgs.discord
          pkgs.obs-studio
        ];
      }
    )
  ];
}
