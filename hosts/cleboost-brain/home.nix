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
    EOF

    rm -f "$out/execs.lua"
    # Attendre monitors.lua puis recalcul workspaces (évite DP-1/DP-3 inversés)
    cat > "$out/execs.lua" <<'EOF'
    hl.on("hyprland.start", function()
        hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE XDG_SESSION_CLASS")
        hl.exec_cmd("systemctl --user start nixos-fake-graphical-session.target")
        hl.exec_cmd("systemctl --user restart xdg-desktop-portal-hyprland.service xdg-desktop-portal.service")
        hl.exec_cmd("noctalia")
        hl.exec_cmd("hyprctl dispatch 'hl.dsp.submap(\"global\")'")
        hl.exec_cmd("systemctl --user start localsearch-3.service")
        hl.exec_cmd("bash -c 'sleep 0.8; $HOME/.config/hypr/scripts/manage_workspaces.sh --once'")
    end)

    local ok, groups = pcall(require, "autostart._groups")
    if ok and type(groups) == "table" then
        for _, group in ipairs(groups) do
            pcall(require, "autostart." .. group)
        end
    end
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
