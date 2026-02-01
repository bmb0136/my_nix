{
  pkgs ? import <nixpkgs> {},
  stdenvNoCC ? pkgs.stdenvNoCC,
  fetchurl ? pkgs.fetchurl,
  ...
}: let
  version = "4.2.1";
in stdenvNoCC.mkDerivation {
    pname = "Monocraft";
    inherit version;

    src = fetchurl {
      url = "https://github.com/IdreesInc/Monocraft/releases/download/v${version}/Monocraft-nerd-fonts-patched.ttc";
      hash = "sha256-Z/iP+efGVg9s9g+wYv01OnL2LcJlRGKVDGW2PtU9l1Q=";
    };

    dontUnpack = true;

    installPhase = ''
      mkdir -p "$out/share/fonts"
      cp "$src" "$out/share/fonts/Monocraft.ttc"
    '';
}
