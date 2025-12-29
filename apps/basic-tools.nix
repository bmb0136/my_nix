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

    (pkgs.writeShellApplication rec {
      name = "mkvim";
      text = ''
        if [[ $# -lt 1 ]]; then
          echo "Usage: ${name} <language> [nvim arguments]"
          exit 1
        fi
        lang=$1
        shift
        nix run "${inputs.my_nvim}#$lang" -- "$@"
      '';
    })
  ];
}
