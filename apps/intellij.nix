{ pkgs, inputs, ... }:
{
  environment.systemPackages =
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
        ];
      })
    ];
}
