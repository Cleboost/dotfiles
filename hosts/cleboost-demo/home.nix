# Demo-specific changes leave the shared themes, packages, shortcuts intact.
{ lib, pkgs, ... }:

let
  demoMonitors = ''
    -- Hardware-independent layout: native resolution, automatic arrangement.
    hl.monitor({
        output = "",
        mode = "preferred",
        position = "auto",
        scale = 1,
    })
  '';

in
{
  imports = [
    ./noctalia.nix
  ];

  xdg.configFile."hypr/core/monitors.lua".text = lib.mkForce demoMonitors;

  # GPU variables must come from the running hardware/drivers, not the ASUS.
  xdg.configFile."hypr/gpu-env.lua".text = "-- Generic GPU: use compositor autodetection\n";

  # Show the look without launching Discord and Steam on somebody else's PC.
  xdg.configFile."hypr/autostart/_groups.lua".text =
    lib.mkForce ''return { "base-apps" }
    '';
}
