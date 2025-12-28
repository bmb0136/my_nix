{ inputs, pkgs, ... }:
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

    (pkgs.writeShellApplication {
      name = "mkvim";
      text = ''
        lang=$1
        shift
        nix run "${inputs.my_nvim}#$lang" -- "$@"
      '';
    })
  ];
}
