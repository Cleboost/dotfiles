# Écrans et workspaces fixes de la tour.
{ lib, ... }:

let
  left = "DP-3";
  right = "DP-1";

  workspaceRule = { workspace, monitor, default ? false }:
    "hl.workspace_rule({ workspace = ${toString workspace}, monitor = \"${monitor}\", default = ${if default then "true" else "false"} })";

  workspaces = lib.concatStringsSep "\n" (
    [ "-- cleboost-brain: workspaces fixes" ]
    ++ map (w: workspaceRule { workspace = w; monitor = left; default = w == 1; }) (lib.range 1 10)
    ++ map (w: workspaceRule { workspace = w; monitor = right; default = w == 11; }) (lib.range 11 20)
  );

  monitors = ''
    -- cleboost-brain: dual Eizo EV2216W
    hl.monitor({
        output   = "",
        mode     = "preferred",
        position = "auto",
        scale    = 1,
    })

    hl.monitor({
        output   = "desc:Eizo Nanao Corporation EV2216W 66312076",
        mode     = "1680x1050@59.88",
        position = "0x0",
        scale    = 1,
    })

    hl.monitor({
        output   = "desc:Eizo Nanao Corporation EV2216W 70457074",
        mode     = "1680x1050@59.88",
        position = "1680x0",
        scale    = 1,
    })
  '';
in
{
  xdg.configFile."hypr/core/monitors.lua".text = lib.mkForce monitors;
  xdg.configFile."hypr/workspaces.lua".text = workspaces;
}
