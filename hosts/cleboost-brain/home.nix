# ──────────────────────────────────────────────────────────────────────────────
# hosts/cleboost-brain/home.nix — Home Manager overrides (tower only)
# ──────────────────────────────────────────────────────────────────────────────
{ lib, pkgs, ... }:

let
  # Gauche = DP-3 (66312076), droite = DP-1 (70457074) — ports fixes sur la tour
  brainLeftMonitor = "DP-3";
  brainRightMonitor = "DP-1";

  mkWorkspaceRule =
    { workspace, monitor, default ? false }:
    "hl.workspace_rule({ workspace = ${toString workspace}, monitor = \"${monitor}\", default = ${if default then "true" else "false"} }})";

  brainWorkspaces = lib.concatStringsSep "\n" (
    [ "-- cleboost-brain: workspaces fixes (cleboost.hypr.dynamicWorkspaces = false)" ]
    ++ map (w: mkWorkspaceRule {
      workspace = w;
      monitor = brainLeftMonitor;
      default = w == 1;
    }) (lib.range 1 10)
    ++ map (w: mkWorkspaceRule {
      workspace = w;
      monitor = brainRightMonitor;
      default = w == 11;
    }) (lib.range 11 20)
  );

  brainMonitors = ''
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

  noctaliaConfig = builtins.readFile ../../modules/home/desktop/noctalia/config.toml;
  brainNoctalia = builtins.replaceStrings
    [
      ''center = ["media", "fan-control"]''
      ''    "cleboost/asus-fans-controller-ec",''
      ''output     = "DP-2"'' # widgets bureau → DP-1 (Eizo)
    ]
    [
      ''center = ["media"]''
      ""
      ''output     = "DP-1"''
    ]
    noctaliaConfig;
in
{
  imports = [
    ./gpu-env.nix
  ];

  cleboost.beamng.cheatMenu = {
    enable = true;
    installPaths = [
      "/home/cleboost/.local/share/Steam/steamapps/common/BeamNG.drive"
    ];
  };

  home.packages = with pkgs; [
    nvtopPackages.nvidia
    lm_sensors
    (callPackage ../../pkgs/codex-chatgpt-web.nix { })
  ];

  xdg.configFile."hypr/core/monitors.lua".text = lib.mkForce brainMonitors;

  xdg.configFile."hypr/workspaces.lua".text = brainWorkspaces;

  xdg.configFile."noctalia/config.toml".source =
    lib.mkForce (pkgs.writeText "noctalia-brain.toml" brainNoctalia);
}
