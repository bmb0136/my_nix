{
  pkgs ? import <nixpkgs> { },
  ...
}:
pkgs.stdenvNoCC.mkDerivation rec {
  name = "tag-wrangler";
  version = "0.6.4";

  srcs = pkgs.fetchzip {
    url = "https://github.com/pjeby/${name}/releases/download/${version}/${name}.zip";
    hash = "sha256-s85VVAqn6Ob0iz2VsbuRAqJGv4uYV/VNMzmeX1jdsA4=";
  };

  buildPhase = ''
    mkdir -p "$out"
    cp ./* "$out/"
  '';
}
