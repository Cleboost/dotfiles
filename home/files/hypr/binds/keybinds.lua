-- Applications & Window Management Keybinds

-- Apps
hl.bind("SUPER + T", hl.dsp.exec_cmd("kitty -1"))
hl.bind("SUPER + E", hl.dsp.exec_cmd("nautilus -w"))
hl.bind("SUPER + W", hl.dsp.exec_cmd("google-chrome-stable"))
hl.bind("SUPER + C", hl.dsp.exec_cmd("cursor"))
hl.bind("SUPER + O", hl.dsp.exec_cmd("obsidian"))
hl.bind("SUPER + A", hl.dsp.exec_cmd("kitty agy"))
hl.bind("SUPER + SHIFT + A", hl.dsp.exec_cmd("kitty agy --continue"))

-- Utilities (Noctalia Screenshots & Tools)
hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd("noctalia msg screenshot-region"))
hl.bind("SUPER + SHIFT + D", hl.dsp.exec_cmd("noctalia msg screenshot-annotate"))
hl.bind("Print", hl.dsp.exec_cmd("noctalia msg screenshot-annotate"))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("noctalia msg screenshot-fullscreen"))
hl.bind("SUPER + X", hl.dsp.exec_cmd("dictate"))
hl.bind("SUPER + SHIFT + C", hl.dsp.exec_cmd("hyprpicker -a"), { desc = "Color picker" })
hl.bind("SUPER + H", hl.dsp.exec_cmd("~/.config/hypr/hyprland/scripts/hotspot.sh"), { desc = "Launch Hotspot" })

-- Zoom & Screen
hl.bind("SUPER + Z", hl.dsp.exec_cmd("~/.config/hypr/hyprland/scripts/cursor_zoom.sh up"))
hl.bind("SUPER + SHIFT + Z", hl.dsp.exec_cmd("~/.config/hypr/hyprland/scripts/cursor_zoom.sh reset"))

-- Window Actions
hl.bind("SUPER + Q", hl.dsp.window.close())
hl.bind("SUPER + ALT + space", hl.dsp.window.float({ action = "toggle" }))
hl.bind("SUPER + F", hl.dsp.window.fullscreen(0))
hl.bind("SUPER + SHIFT + ALT + Q", hl.dsp.exec_cmd("hyprctl kill"))

-- Mouse Window Controls
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind("SUPER + mouse:274", hl.dsp.window.drag(), { mouse = true })

-- Keyboard Focus
hl.bind("SUPER + Left", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + Right", hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + Up", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + Down", hl.dsp.focus({ direction = "down" }))
hl.bind("SUPER + bracketleft", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + bracketright", hl.dsp.focus({ direction = "right" }))

-- Keyboard Move
hl.bind("SUPER + SHIFT + Left", hl.dsp.window.move({ direction = "left" }))
hl.bind("SUPER + SHIFT + Right", hl.dsp.window.move({ direction = "right" }))
hl.bind("SUPER + SHIFT + Up", hl.dsp.window.move({ direction = "up" }))
hl.bind("SUPER + SHIFT + Down", hl.dsp.window.move({ direction = "down" }))

-- Media Controls (Keyboard)
hl.bind("SUPER + SHIFT + P", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("SUPER + SHIFT + N", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("SUPER + SHIFT + B", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- XF86 Media Keys
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- Extra Mouse Media
hl.bind("SUPER + SHIFT + ALT + mouse:275", hl.dsp.exec_cmd("playerctl previous"))
hl.bind("SUPER + SHIFT + ALT + mouse:276", hl.dsp.exec_cmd("playerctl next"))
