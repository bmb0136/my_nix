pushd "$(dirname "$(realpath "$0")")" >/dev/null || exit 1
"$(nix-build updater.nix --no-out-link)/bin/updater"
popd >/dev/null || exit 1
