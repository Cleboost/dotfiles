# Un fichier .nix par groupe — paquets + imports config liés au groupe.
{ lib, ... }:

let
  groupFiles =
    lib.filter (n: n != "module.nix" && lib.hasSuffix ".nix" n)
      (builtins.attrNames (builtins.readDir ./.));
in
{
  imports = map (name: ./. + "/${name}") groupFiles;

  xdg.mimeApps.enable = true;
}
