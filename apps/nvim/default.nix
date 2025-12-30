{
  config,
  inputs,
  pkgs,
  ...
}:
{
  environment.systemPackages =
    let
      my_nvim = inputs.my_nvim.packages.${pkgs.stdenv.hostPlatform.system};
      enableOllama = config.services.ollama.enable;
      modules = if enableOllama then [ (import ./ollama.nix) ] else [ ];
    in
    [
      (my_nvim.default.override { inherit modules; })
      (my_nvim.mkvim.override { inherit modules; })
    ];
}
