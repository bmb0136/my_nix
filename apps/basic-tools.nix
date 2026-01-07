{ pkgs, ... }:
{
  environment.shellAliases = {
    l = "ls -lah";
    ll = "ls -l";
    ls = "ls --color=tty";
    cls = "clear";
    grep = "grep --color=auto";
  };

  environment.systemPackages = with pkgs; [
    btop
    htop
    wget
    curl
    git
    fzf
    traceroute
    file
  ];
}
