# Generates hypr/autostart/_groups.lua from cleboost.* options.
{ lib, osConfig, ... }:

let
  enabled =
    lib.optional osConfig.cleboost.desktop "base-apps"
    ++ lib.optional (osConfig.cleboost.social.discord || osConfig.cleboost.spotify) "social"
    ++ lib.optional osConfig.cleboost.gaming "gaming";
in
{
  xdg.configFile."hypr/autostart/_groups.lua".text = "return { ${
    lib.concatStringsSep ", " (map (g: "\"${g}\"") enabled)
  } }\n";
}
