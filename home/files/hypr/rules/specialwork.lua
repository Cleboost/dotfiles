-- Special Workspaces (Comm & Music)

-- Window Rules (Direct assignment)
hl.window_rule({
    match = { class = "^(discord)$" },
    workspace = "special:comm silent",
    no_initial_focus = true,
})

hl.window_rule({
    match = { class = "^([Ss]potify|fastpotify)$" },
    workspace = "special:music silent",
    no_initial_focus = true,
})

-- Workspace Configuration
hl.workspace_rule({
    workspace = "special:music",
    gaps_out = 50,
})

hl.workspace_rule({
    workspace = "special:comm",
    gaps_out = 50,
})
