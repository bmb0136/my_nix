{ lib, ... }:
let
  folders = [
    "app"
  ];
  subfolders = lib.mergeAttrsList (
    map (
      f:
      lib.pipe (builtins.readDir ./${f}) [
        (lib.filterAttrs (n: v: v == "directory"))
        (builtins.mapAttrs (n: _: {
          name = "${f}-${n}";
          value = ./${f}/${n};
        }))
      ]
    ) folders
  );

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
