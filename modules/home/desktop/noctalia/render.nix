# Merge shared config.toml with cleboost.noctalia host options.
{ lib, cfg, base }:
let
  fmtTomlStringList = items:
    "["
    + lib.concatStringsSep ", " (map (item: "\"${item}\"") items)
    + "]";

  barCenterLine = "center = ${fmtTomlStringList cfg.bar.center}";

  bongocatInputs = "input_devices  = ${fmtTomlStringList cfg.bongocat.inputDevices}";

  pluginLines = lib.concatStringsSep "\n" (map (p: "    \"${p}\",") cfg.plugins.enabled);

  pluginsBlock = "enabled = [\n${pluginLines}\n]";

  desktopWidgetsFlag =
    if cfg.desktopWidgets.enable then
      "enabled        = true"
    else
      "enabled        = false";
in
lib.pipe base [
  (builtins.replaceStrings [ ''center = ["media", "fan-control"]'' ] [ barCenterLine ])
  (builtins.replaceStrings
    [ ''input_devices  = ["/dev/input/by-path/platform-i8042-serio-0-event-kbd"]'' ]
    [ bongocatInputs ])
  (builtins.replaceStrings [ ''output     = "DP-2"'' ] [ ''output     = "${cfg.desktopWidgets.output}"'' ])
  (builtins.replaceStrings
    [ ''[desktop_widgets]
enabled        = true'' ]
    [ ''[desktop_widgets]
${desktopWidgetsFlag}'' ])
  (builtins.replaceStrings
    [
      ''[plugins]
enabled = [
    "noctalia/bongocat",
    "noctalia/screen_recorder",
    "cleboost/anilist",
    "cleboost/asus-fans-controller-ec",
    "cleboost/librelinkup"
]''
    ]
    [
      ''[plugins]
${pluginsBlock}''
    ])
]
