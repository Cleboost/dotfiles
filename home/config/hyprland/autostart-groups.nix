# Génère hypr/autostart/_groups.lua depuis cleboost.groups.
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
