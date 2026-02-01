{ pkgs, ... }:
{
  imports = [
    ./git.nix
  ];

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
    fzf
    traceroute
    file
    unzip
    fastfetch
  ];
}
