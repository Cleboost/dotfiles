# Clé USB — écrans auto, pas de layout fixe brain/sage.
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
}
