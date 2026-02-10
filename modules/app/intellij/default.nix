{
  pkgs,
  inputs,
  lib,
  config,
  ...
}:
{

  options.bmb0136.modules.app-intellij.enable = lib.mkEnableOption "intellij";

  config.environment.systemPackages = lib.mkIf config.bmb0136.modules.app-intellij.enable (
    let
      inherit (pkgs) jetbrains;
      system = pkgs.stdenv.hostPlatform.system;

      mkIde =
        {
          name,
          pkg,
          plugins,
        }:
        (jetbrains.plugins.addPlugins pkg (
          map (x: inputs.nix-jetbrains-plugins.plugins.${system}.${name}.${pkg.version}.${x}) plugins
        ));
    in
    [
      (mkIde {
        name = "idea";
        pkg = jetbrains.idea-oss;
        plugins = [
          "com.demonwav.minecraft-dev"
          "IdeaVIM"
          "nix-idea"
        ];
      })
    ]
  );
}
