{
  pkgs ? import <nixpkgs> { },
  ...
}:
pkgs.stdenvNoCC.mkDerivation rec {
  name = "obsidian-better-export-pdf";
  version = "1.11.0";

  srcs = pkgs.fetchzip {
    url = "https://github.com/l1xnan/${name}/releases/download/${version}/${name}.zip";
    hash = "sha256-9q5gHFJsMXnS+tskkmXaUzoNvWywtqpnboGEff4vfPE=";
  };

  buildPhase = ''
    mkdir -p "$out"
    cp ./* "$out/"
  '';
}
