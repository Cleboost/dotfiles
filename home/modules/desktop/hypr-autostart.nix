# Generates hypr/autostart/_groups.lua from cleboost.groups (no hardcoded list in execs.lua)
{ config, lib, ... }:

let
  autostartGroups = [
    "base-apps"
    "social"
    "gaming"
  ];
  enabled = lib.filter (g: lib.elem g config.cleboost.groups) autostartGroups;
in
{
  xdg.configFile."hypr/autostart/_groups.lua".text =
    "return { ${lib.concatStringsSep ", " (map (g: "\"${g}\"") enabled)} }\n";
}
