{
  pkgs ? import <nixpkgs> { },
  lib ? pkgs.lib,
  ...
}:
let
  python = pkgs.python3.withPackages (pp: with pp; [ requests ]);
in
pkgs.stdenv.mkDerivation rec {
  name = "updater";
  dontUnpack = true;
  nativeBuildInputs = [ pkgs.makeWrapper ];
  buildPhase = ''
    mkdir -p $out/bin/
    makeWrapper "${python}/bin/python3" "$out/bin/${name}" \
      --set CHROME_VERSION "${lib.versions.major pkgs.ungoogled-chromium.version}" \
      --add-flags "${./updater.py}"
  '';
}
