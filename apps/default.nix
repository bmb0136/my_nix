{ inputs, pkgs, ... }:
{
  imports = [
    ./tmux.nix
    ./nix.nix
    ./basic-tools.nix
    ./nvim
  ];
}
