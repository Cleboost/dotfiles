# Écrans et workspaces fixes — tour ASUS dual.
{ lib, ... }:

let
  # Gauche 0x0 (VY279HGE) → 11–20 ; droite 1920x0 (VG2791R) → 1–10.
  left = "HDMI-A-1";
  right = "DP-3";

  leftDesc = "desc:ASUSTek COMPUTER INC VY279HGE S7LMQS001610";
  rightDesc = "desc:ASUSTek COMPUTER INC VG2791R S3LMDW006158";

  workspaceRule = { workspace, monitor, default ? false }:
    "hl.workspace_rule({ workspace = ${toString workspace}, monitor = \"${monitor}\", default = ${if default then "true" else "false"} })";

  workspaces = lib.concatStringsSep "\n" (
    [ "-- cleboost-brain: workspaces fixes (gauche 11–20, droite 1–10)" ]
    ++ map (w: workspaceRule { workspace = w; monitor = right; default = w == 1; }) (lib.range 1 10)
    ++ map (w: workspaceRule { workspace = w; monitor = left; default = w == 11; }) (lib.range 11 20)
  );

  monitors = ''
    -- cleboost-brain: dual ASUS
    hl.monitor({
        output   = "",
        mode     = "preferred",
        position = "auto",
        scale    = 1,
    })

    hl.monitor({
        output   = "${leftDesc}",
        mode     = "1920x1080@144",
        position = "0x0",
        scale    = 1,
        vrr      = 1,
    })

    hl.monitor({
        output   = "${rightDesc}",
        mode     = "1920x1080@144",
        position = "1920x0",
        scale    = 1,
        vrr      = 1,
    })
  '';
in
{
  xdg.configFile."hypr/core/monitors.lua".text = lib.mkForce monitors;
  xdg.configFile."hypr/workspaces.lua".text = workspaces;
}
