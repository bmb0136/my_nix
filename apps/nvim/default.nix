{
  config,
  inputs,
  pkgs,
  ...
}:
{
  environment.systemPackages =
    let
      enableOllama = config.services.ollama.enable;
    in
    [
      (inputs.my_nvim.packages.${pkgs.stdenv.hostPlatform.system}.default.override {
        modules = if enableOllama then [ (import ./ollama.nix) ] else [ ];
      })

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
          args="enable-$lang=true;"
          if ${if enableOllama then "true" else "false"}; then
            args+='modules=[${builtins.readFile ./ollama.nix}];'
          fi
          result=$(nix-build --expr "(builtins.getFlake \"$my_nvim\").packages.\"$system\".default.override { $args }" --no-out-link)
          "$result/bin/nvim" "$@"
        '';
      })
    ];
}
