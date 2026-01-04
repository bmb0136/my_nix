{
  config,
  inputs,
  pkgs,
  lib,
  ...
}:
let
  my_nvim = inputs.my_nvim.packages.${pkgs.stdenv.hostPlatform.system};
  modules = [ ];
in
{
  options.bmb0136.nvim.add-lang-nvims = lib.mkEnableOption "Language-specific nvim packages";

  config.environment.sessionVariables = {
    EDITOR = lib.mkForce "nvim";
  };

  config.environment.systemPackages = [
    (my_nvim.default.override { inherit modules; })
  ]
  ++ (
    if config.bmb0136.nvim.add-lang-nvims then
      (
        let
          nvim-c = my_nvim.c.override { inherit modules; };
          nvim-cs = my_nvim.csharp.override {
            inherit modules;
            enable-fsharp = true;
            enable-html = true;
            enable-sql = true;
          };
          nvim-js = my_nvim.ts.override {
            inherit modules;
            enable-svelte = true;
            enable-tailwind = true;
          };

          nvims = {
            inherit nvim-c;
            nvim-cpp = nvim-c;

            nvim-rust = my_nvim.rust.override {
              inherit modules;
              enable-c = true;
            };

            nvim-py = my_nvim.python.override { inherit modules; };

            inherit nvim-cs;
            nvim-fs = nvim-cs;

            inherit nvim-js;
            nvim-ts = nvim-js;
          };
          replaceName =
            name: val:
            pkgs.writeShellScriptBin name ''
              "${val}/bin/nvim" "$@"
            '';
        in
        lib.mapAttrsToList replaceName nvims
      )
    else
      [ ]
  );
}
