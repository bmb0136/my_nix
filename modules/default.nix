{ lib, ... }:
let
  folders = [
    "app"
  ];
  subfolders = map (
    f:
    lib.pipe (builtins.readDir ./${f}) [
      (lib.filterAttrs (n: v: v == "directory"))
      (map (n: {
        name = "${f}-${n}";
        value = ./${f}/${n};
      }))
      (builtins.listToAttrs)
    ]
  ) folders;

  allModules = subfolders;
in
{
  flake.nixosModules =
    (builtins.mapAttrs (
      name: path:
      (
        { lib, ... }:
        {
          imports = [ path ];
          bmb0136.modules.${name}.enable = lib.mkDefault true;
        }
      )
    ) allModules)
    // {
      default = {
        imports = builtins.attrValues allModules;
      };
    };
}
