{ ... }:
{
  home-manager.sharedModules = [
    {
      programs.alacritty = {
        enable = true;
        settings = {
          window.startup_mode = "Maximized";
        };
      };
    }
  ];
}
