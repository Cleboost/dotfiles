# One .nix file per group — packages + config imports tied to the group.
{ lib, ... }:

let
  groupFiles = lib.filter (n: n != "module.nix" && lib.hasSuffix ".nix" n) (
    builtins.attrNames (builtins.readDir ./.)
  );
in
{
  imports = map (name: ./. + "/${name}") groupFiles;

  xdg.mimeApps.enable = true;
}
