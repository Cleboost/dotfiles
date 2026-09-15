-- Core Environment Variables
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

-- XDG & Applications
hl.env("XDG_DATA_DIRS", "/home/cleboost/.local/share:/etc/profiles/per-user/cleboost/share:/run/current-system/sw/share:/usr/share")
hl.env("TERMINAL", "kitty -1")
hl.env("NAUTILUS_4_EXTENSION_DIR", "/run/current-system/sw/lib/nautilus/extensions-4")

-- Toolkit Themes (QT/GTK)
hl.env("QT_QPA_PLATFORM", "wayland")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_STYLE_OVERRIDE", "kvantum")
hl.env("GTK_ICON_THEME", "WhiteSur-dark")
hl.env("GTK_USE_PORTAL", "0")
hl.env("GSK_RENDERER", "gl")

-- Cursor
hl.env("XCURSOR_THEME", "cleboost-cursor")
hl.env("XCURSOR_SIZE", "18")
hl.env("HYPRCURSOR_THEME", "cleboost-cursor")
hl.env("HYPRCURSOR_SIZE", "18")

-- PRIME / NVIDIA GPU vars: home/modules/gpu-env.nix (gpu-env.lua + sessionVariables)
