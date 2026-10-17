# Écrans auto, pas d'autostart Discord/Steam.
{ lib, ... }:

{
  xdg.configFile."hypr/core/monitors.lua".text = lib.mkForce ''
    hl.monitor({
        output = "",
        mode = "preferred",
        position = "auto",
        scale = 1,
    })
  '';

  xdg.configFile."hypr/gpu-env.lua".text = "-- Generic GPU: use compositor autodetection\n";

  xdg.configFile."hypr/autostart/_groups.lua".text = lib.mkForce ''
    return { "base-apps" }
  '';
}
