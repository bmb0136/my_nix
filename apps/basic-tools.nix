{ pkgs, ... }: {
  environment.shellAliases = {
    l = "ls -lah";
    ll = "ls -l";
    ls = "ls --color=tty";
    cls = "clear";
    htop = "btop";
  };

  environment.systemPackages = [
    pkgs.btop
  ];
}
