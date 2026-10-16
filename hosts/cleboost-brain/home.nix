# ──────────────────────────────────────────────────────────────────────────────
# hosts/cleboost-brain/home.nix — Home Manager overrides (tower only)
# ──────────────────────────────────────────────────────────────────────────────
{ lib, pkgs, ... }:

let
  brainHyprCore = pkgs.runCommand "cleboost-brain-hypr-core" { } ''
    mkdir -p "$out"
    cp -r ${../../modules/home/desktop/hyprland/core}/. "$out/"
    rm -f "$out/monitors.lua"
    cat > "$out/monitors.lua" <<'EOF'
    -- cleboost-brain: dual Eizo EV2216W (pas les règles laptop / ASUS)
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

    hl.monitor({
        output   = "DP-1",
        mode     = "1680x1050@59.88",
        position = "0x0",
        scale    = 1,
    })

    hl.monitor({
        output   = "DP-3",
        mode     = "1680x1050@59.88",
        position = "1680x0",
        scale    = 1,
    })
    EOF
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

  xdg.configFile."hypr/core".source = lib.mkForce brainHyprCore;

  xdg.configFile."noctalia/config.toml".source =
    lib.mkForce (pkgs.writeText "noctalia-brain.toml" brainNoctalia);
}
