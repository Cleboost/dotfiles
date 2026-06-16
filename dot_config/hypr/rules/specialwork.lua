-- Special Workspaces Configuration

hl.window_rule({ match = { class = "^(discord)$" }, workspace = "special:comm silent", no_initial_focus = true })
hl.window_rule({ match = { class = "^(Spotify)$" }, workspace = "special:music silent", no_initial_focus = true })

hl.workspace_rule({ workspace = "special:music", gaps_out = 50 })
hl.workspace_rule({ workspace = "special:comm", gaps_out = 50 })

hl.on("hyprland.start", function()
    hl.exec_cmd("discord")
    hl.exec_cmd("spotify")
end)
