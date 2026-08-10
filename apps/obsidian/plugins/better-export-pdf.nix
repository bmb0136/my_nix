{
  pkgs ? import <nixpkgs> { },
  ...
}:
pkgs.stdenvNoCC.mkDerivation rec {
  name = "obsidian-better-export-pdf";
  version = "2.0.3";

  srcs = pkgs.fetchzip {
    url = "https://github.com/l1xnan/${name}/releases/download/${version}/${name}.zip";
    hash = "sha256-3K7oxMRn7DC9fjggIuTzjFzr4D2OzDpnyyXuxXi1WN8=";
  };

  buildPhase = ''
    mkdir -p "$out"
    cp ./* "$out/"
  '';
}
