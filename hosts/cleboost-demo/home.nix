# Demo-specific changes leave the shared themes, packages, shortcuts intact.
{ lib, pkgs, ... }:

let
  # A directory is already managed as "hypr/core" by the shared Home Manager
  # module, so replace the directory as a whole to avoid overlapping targets.
  demoCore = pkgs.runCommand "cleboost-demo-hypr-core" { } ''
    mkdir -p "$out"
    cp -r ${../../home/modules/desktop/hyprland/core}/. "$out/"
    cat > "$out/monitors.lua" <<'EOF'
    -- Hardware-independent layout: native resolution, automatic arrangement.
    hl.monitor({
        output = "",
        mode = "preferred",
        position = "auto",
        scale = 1,
    })
    EOF
  '';

  noctaliaConfig = builtins.readFile ../../home/modules/desktop/noctalia/config.toml;
  demoNoctalia = builtins.replaceStrings
    [
      ''center = ["media", "fan-control"]''
      ''input_devices  = ["/dev/input/by-path/platform-i8042-serio-0-event-kbd"]''
      ''enabled        = true
schema_version = 1''
      ''    "cleboost/anilist",''
      ''    "cleboost/asus-fans-controller-ec",''
      ''    "cleboost/librelinkup"''
    ]
    [
      ''center = ["media"]''
      ''input_devices  = []''
      ''enabled        = false
schema_version = 1''
      ""
      ""
      ""
    ] noctaliaConfig;
in
{
  # The original machine's hard-coded monitor port names never reach the demo.
  xdg.configFile."hypr/core".source = lib.mkForce demoCore;

  # GPU variables must come from the running hardware/drivers, not the ASUS.
  xdg.configFile."hypr/gpu-env.lua".text = "-- Generic GPU: use compositor autodetection\n";

  xdg.configFile."noctalia/config.toml".source =
    lib.mkForce (pkgs.writeText "noctalia-demo.toml" demoNoctalia);

  # Show the look without launching Discord and Steam on somebody else's PC.
  xdg.configFile."hypr/autostart/_groups.lua".text =
    lib.mkForce ''return { "base-apps" }
    '';
}
