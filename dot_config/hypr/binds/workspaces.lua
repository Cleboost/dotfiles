-- Workspaces Navigation & Management

-- Number Keys Focus
hl.bind("SUPER + code:10", hl.dsp.exec_cmd("~/.config/hypr/hyprland/scripts/workspace_action.sh workspace 1"))
hl.bind("SUPER + code:11", hl.dsp.exec_cmd("~/.config/hypr/hyprland/scripts/workspace_action.sh workspace 2"))
hl.bind("SUPER + code:12", hl.dsp.exec_cmd("~/.config/hypr/hyprland/scripts/workspace_action.sh workspace 3"))
hl.bind("SUPER + code:13", hl.dsp.exec_cmd("~/.config/hypr/hyprland/scripts/workspace_action.sh workspace 4"))
hl.bind("SUPER + code:14", hl.dsp.exec_cmd("~/.config/hypr/hyprland/scripts/workspace_action.sh workspace 5"))
hl.bind("SUPER + code:15", hl.dsp.exec_cmd("~/.config/hypr/hyprland/scripts/workspace_action.sh workspace 6"))
hl.bind("SUPER + code:16", hl.dsp.exec_cmd("~/.config/hypr/hyprland/scripts/workspace_action.sh workspace 7"))
hl.bind("SUPER + code:17", hl.dsp.exec_cmd("~/.config/hypr/hyprland/scripts/workspace_action.sh workspace 8"))
hl.bind("SUPER + code:18", hl.dsp.exec_cmd("~/.config/hypr/hyprland/scripts/workspace_action.sh workspace 9"))
hl.bind("SUPER + code:19", hl.dsp.exec_cmd("~/.config/hypr/hyprland/scripts/workspace_action.sh workspace 10"))

-- Keypad Focus
hl.bind("SUPER + code:87", hl.dsp.exec_cmd("~/.config/hypr/hyprland/scripts/workspace_action.sh workspace 1"), { dont_inhibit = true })
hl.bind("SUPER + code:88", hl.dsp.exec_cmd("~/.config/hypr/hyprland/scripts/workspace_action.sh workspace 2"), { dont_inhibit = true })
hl.bind("SUPER + code:89", hl.dsp.exec_cmd("~/.config/hypr/hyprland/scripts/workspace_action.sh workspace 3"), { dont_inhibit = true })
hl.bind("SUPER + code:83", hl.dsp.exec_cmd("~/.config/hypr/hyprland/scripts/workspace_action.sh workspace 4"), { dont_inhibit = true })
hl.bind("SUPER + code:84", hl.dsp.exec_cmd("~/.config/hypr/hyprland/scripts/workspace_action.sh workspace 5"), { dont_inhibit = true })
hl.bind("SUPER + code:85", hl.dsp.exec_cmd("~/.config/hypr/hyprland/scripts/workspace_action.sh workspace 6"), { dont_inhibit = true })
hl.bind("SUPER + code:79", hl.dsp.exec_cmd("~/.config/hypr/hyprland/scripts/workspace_action.sh workspace 7"), { dont_inhibit = true })
hl.bind("SUPER + code:80", hl.dsp.exec_cmd("~/.config/hypr/hyprland/scripts/workspace_action.sh workspace 8"), { dont_inhibit = true })
hl.bind("SUPER + code:81", hl.dsp.exec_cmd("~/.config/hypr/hyprland/scripts/workspace_action.sh workspace 9"), { dont_inhibit = true })
hl.bind("SUPER + code:90", hl.dsp.exec_cmd("~/.config/hypr/hyprland/scripts/workspace_action.sh workspace 10"), { dont_inhibit = true })

-- Directional & Mouse Focus
hl.bind("CTRL + SUPER + Right", hl.dsp.focus({ workspace = "r+1" }))
hl.bind("CTRL + SUPER + Left", hl.dsp.focus({ workspace = "r-1" }))
hl.bind("SUPER + Page_Down", hl.dsp.focus({ workspace = "+1" }))
hl.bind("SUPER + Page_Up", hl.dsp.focus({ workspace = "-1" }))

-- Move Windows (Silent)
hl.bind("SUPER + ALT + code:10", hl.dsp.exec_cmd("~/.config/hypr/hyprland/scripts/workspace_action.sh movetoworkspacesilent 1"))
hl.bind("SUPER + ALT + code:11", hl.dsp.exec_cmd("~/.config/hypr/hyprland/scripts/workspace_action.sh movetoworkspacesilent 2"))
hl.bind("SUPER + ALT + code:12", hl.dsp.exec_cmd("~/.config/hypr/hyprland/scripts/workspace_action.sh movetoworkspacesilent 3"))
hl.bind("SUPER + ALT + code:13", hl.dsp.exec_cmd("~/.config/hypr/hyprland/scripts/workspace_action.sh movetoworkspacesilent 4"))
hl.bind("SUPER + ALT + code:14", hl.dsp.exec_cmd("~/.config/hypr/hyprland/scripts/workspace_action.sh movetoworkspacesilent 5"))
hl.bind("SUPER + ALT + code:15", hl.dsp.exec_cmd("~/.config/hypr/hyprland/scripts/workspace_action.sh movetoworkspacesilent 6"))
hl.bind("SUPER + ALT + code:16", hl.dsp.exec_cmd("~/.config/hypr/hyprland/scripts/workspace_action.sh movetoworkspacesilent 7"))
hl.bind("SUPER + ALT + code:17", hl.dsp.exec_cmd("~/.config/hypr/hyprland/scripts/workspace_action.sh movetoworkspacesilent 8"))
hl.bind("SUPER + ALT + code:18", hl.dsp.exec_cmd("~/.config/hypr/hyprland/scripts/workspace_action.sh movetoworkspacesilent 9"))
hl.bind("SUPER + ALT + code:19", hl.dsp.exec_cmd("~/.config/hypr/hyprland/scripts/workspace_action.sh movetoworkspacesilent 10"))

-- Directional & Mouse Move
hl.bind("SUPER + ALT + Page_Down", hl.dsp.window.move({ workspace = "+1" }))
hl.bind("SUPER + ALT + Page_Up", hl.dsp.window.move({ workspace = "-1" }))
hl.bind("SUPER + ALT + Right", hl.dsp.window.move({ workspace = "+1" }))
hl.bind("SUPER + ALT + Left", hl.dsp.window.move({ workspace = "-1" }))
hl.bind("SUPER + SHIFT + Page_Down", hl.dsp.window.move({ workspace = "r+1" }))
hl.bind("SUPER + SHIFT + Page_Up", hl.dsp.window.move({ workspace = "r-1" }))
hl.bind("CTRL + SUPER + SHIFT + Right", hl.dsp.window.move({ workspace = "r+1" }))
hl.bind("CTRL + SUPER + SHIFT + Left", hl.dsp.window.move({ workspace = "r-1" }))

-- Special Workspaces
hl.bind("SUPER + D", hl.dsp.workspace.toggle_special("comm"))
hl.bind("SUPER + S", hl.dsp.workspace.toggle_special("music"))
hl.bind("CTRL + SUPER + BracketLeft", hl.dsp.focus({ workspace = "-1" }))
hl.bind("CTRL + SUPER + BracketRight", hl.dsp.focus({ workspace = "+1" }))
