-- Standard Applications & Window Management Keybinds

-- Apps
hl.bind("SUPER + T", hl.dsp.exec_cmd("kitty -1"), { description = "Terminal" })
hl.bind("SUPER + SHIFT + T", hl.dsp.exec_cmd("kitty --class ssh-menu -e ~/.local/bin/ssh-menu.sh"), { description = "SSH Selector" })
hl.bind("SUPER + ALT + T", hl.dsp.exec_cmd("kitty --class ssh-menu -e ~/.local/bin/ecosystem-ssh.sh"), { description = "Ecosystem SSH Selector" })
hl.bind("SUPER + E", hl.dsp.exec_cmd("nautilus -w"), { description = "File Manager" })
hl.bind("SUPER + W", hl.dsp.exec_cmd("google-chrome-stable"), { description = "Browser" })
hl.bind("SUPER + U", hl.dsp.exec_cmd("sh -c 'pkill -9 chrome; sleep 0.1; google-chrome-stable --new-window \"https://fr.wikipedia.org\" \"https://docs.google.com\" \"https://www.google.com/search?q=les+oiseaux\"'"), { description = "Reopen Google Chrome with 3 tabs" })
hl.bind("SUPER + O", hl.dsp.exec_cmd("obsidian"), { description = "Obsidian" })

-- Utilities
hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd("noctalia msg screenshot-region"), { description = "Screenshot" })
hl.bind("SUPER + SHIFT + D", hl.dsp.exec_cmd("sh -c 'hyprshot -m region --raw | waytator'"), { description = "Screenshot" })
hl.bind("Print", hl.dsp.exec_cmd("hyprshot -m region --freeze --clipboard-only"), { description = "Screenshot" })
hl.bind("SUPER + X", hl.dsp.exec_cmd("dictate"), { description = "Dictation (Whisper)" })
hl.bind("SUPER + SHIFT + C", hl.dsp.exec_cmd("hyprpicker -a"), { desc = "Color picker" })
hl.bind("SUPER + H", hl.dsp.exec_cmd("~/.config/hypr/hyprland/scripts/hotspot.sh"), { desc = "Launch Hotspot" })
hl.bind("SUPER + SHIFT + H", hl.dsp.exec_cmd("~/.local/bin/ecosystem-share.sh"), { desc = "Ecosystem Handoff (Share Clipboard)" })

-- Zoom & Screen
hl.bind("SUPER + Z", hl.dsp.exec_cmd("~/.config/hypr/hyprland/scripts/cursor_zoom.sh up"))
hl.bind("SUPER + A", hl.dsp.exec_cmd("~/.config/hypr/hyprland/scripts/cursor_zoom.sh down"))
hl.bind("SUPER + SHIFT + Z", hl.dsp.exec_cmd("~/.config/hypr/hyprland/scripts/cursor_zoom.sh reset"))

-- Window Actions
hl.bind("SUPER + Q", hl.dsp.window.close(), { description = "Close window" })
hl.bind("SUPER + ALT + Space", hl.dsp.window.float({ action = "toggle" }), { description = "Toggle Float" })
hl.bind("SUPER + F", hl.dsp.window.fullscreen(), { description = "Toggle Fullscreen" })
hl.bind("SUPER + SHIFT + ALT + Q", hl.dsp.exec_cmd("hyprctl kill"), { description = "Force Kill (xkill style)" })

-- Focus with mouse
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind("SUPER + mouse:274", hl.dsp.window.drag(), { mouse = true })

-- Focus with keyboard
hl.bind("SUPER + Left", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + Right", hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + Up", hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + Down", hl.dsp.focus({ direction = "down" }))
hl.bind("SUPER + BracketLeft", hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + BracketRight", hl.dsp.focus({ direction = "right" }))

-- Move with keyboard
hl.bind("SUPER + SHIFT + Left", hl.dsp.window.move({ direction = "left" }))
hl.bind("SUPER + SHIFT + Right", hl.dsp.window.move({ direction = "right" }))
hl.bind("SUPER + SHIFT + Up", hl.dsp.window.move({ direction = "up" }))
hl.bind("SUPER + SHIFT + Down", hl.dsp.window.move({ direction = "down" }))

-- Media Controls
hl.bind("SUPER + SHIFT + P", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("SUPER + SHIFT + N", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("SUPER + SHIFT + B", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

