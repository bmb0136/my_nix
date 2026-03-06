inputs:
{
  system,
  modules,
  hostBundles ? [ ],
  appBundles ? [ ],
}:
(import ./mkHost.nix) inputs {
  inherit system;
  modules =
    modules ++ (map (x: ./bundles/${x}) hostBundles) ++ (map (x: ../apps/bundles/${x}) appBundles);
  users = [ ];
}
