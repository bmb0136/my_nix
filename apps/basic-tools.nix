{ config, inputs, pkgs, lib, ... }:
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

    inputs.my_nvim.packages.${pkgs.stdenv.hostPlatform.system}.default

    (pkgs.writeShellApplication rec {
      name = "mkvim";
      text = ''
        if [[ $# -lt 1 ]]; then
          echo "Usage: ${name} <language> [nvim arguments]"
          exit 1
        fi
        lang=$1
        shift
        my_nvim="${inputs.my_nvim}"
        system="${pkgs.system}"
        result=$(nix-build --expr "(builtins.getFlake \"$my_nvim\").packages.\"$system\".default.override { enable-$lang=true; }" --no-out-link)
        "$result/bin/nvim" "$@"
      '';
    })
  ];
}
