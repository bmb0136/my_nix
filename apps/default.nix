{ inputs, pkgs, ... }:
{
  imports = [
    ./tmux.nix
    ./nix.nix
    ./basic-tools.nix
  ];

  environment.systemPackages = [
    inputs.my_nvim.packages.${pkgs.stdenv.hostPlatform.system}.default

    pkgs.git
  ];
}
