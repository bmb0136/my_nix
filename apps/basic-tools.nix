{ pkgs, ... }:
{
  environment.shellAliases = {
    l = "ls -lah";
    ll = "ls -l";
    ls = "ls --color=tty";
    cls = "clear";
  };

  environment.systemPackages = [
    pkgs.btop
    pkgs.htop
    pkgs.wget
    pkgs.curl
    pkgs.git
  ];
}
