{
  pkgs ? import <nixpkgs> { },
  ...
}:
pkgs.stdenvNoCC.mkDerivation rec {
  name = "obsidian-git";
  version = "2.36.0";

  srcs = pkgs.fetchzip {
    url = "https://github.com/Vinzent03/${name}/releases/download/${version}/${name}-${version}.zip";
    hash = "sha256-6yKsgQ5HZNZWQscK/1Xm5s6MQe5/9INidju3AqxVoVo=";
  };

  buildPhase = ''
    mkdir -p "$out"
    cp ./* "$out/"
  '';
}
