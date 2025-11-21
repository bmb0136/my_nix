{ inputs, pkgs, ...}:
{
  imports = [];

  environment.systemPackages = [
    inputs.my_nvim.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
