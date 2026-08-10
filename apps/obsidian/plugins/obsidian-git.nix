{
  pkgs ? import <nixpkgs> { },
  ...
}:
pkgs.stdenvNoCC.mkDerivation rec {
  name = "obsidian-git";
  version = "2.38.6";

  srcs = pkgs.fetchzip {
    url = "https://github.com/Vinzent03/${name}/releases/download/${version}/${name}-${version}.zip";
    hash = "sha256-GHaYFW9IL/T4dCxJLZ6A5Y6eQ4h+4aIJs095+/rxdic=";
  };

  buildPhase = ''
    mkdir -p "$out"
    cp ./* "$out/"
  '';
}
