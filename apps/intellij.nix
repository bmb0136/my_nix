{ pkgs, inputs, ... }:
{
  environment.systemPackages =
    let
      inherit (pkgs) jetbrains;
      ide = jetbrains.idea;
      system = pkgs.stdenv.hostPlatform.system;
    in
    [
      (jetbrains.plugins.addPlugins ide (
        map (name: inputs.nix-jetbrains-plugins.plugins.${system}.idea.${ide.version}.${name}) [
          "com.demonwav.minecraft-dev"
          "IdeaVIM"
        ]
      ))
    ];
}
