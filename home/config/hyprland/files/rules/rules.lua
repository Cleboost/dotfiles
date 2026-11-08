-- Window and Layer Rules

-- Floating Dialogs & File Pickers
local dialog_titles = {
    "^(Open File)(.*)$",
    "^(Select a File)(.*)$",
    "^(Open Folder)(.*)$",
    "^(Save As)(.*)$",
}

for _, title_pattern in ipairs(dialog_titles) do
    hl.window_rule({
        match = { title = title_pattern },
        float = true,
        center = true,
    })
end

-- Bitwarden Popup
hl.window_rule({
    match = { class = "^(chrome-nngceckbapebfimnlniiiahkandclblb-Default)$" },
    float = true,
    size = "400 600",
})

-- Kitty: always tile; ignore stray maximize/fullscreen requests from single-instance spawns
hl.window_rule({
    name = "kitty-tiled-terminal",
    match = { class = "^(kitty)$" },
    float = false,
    tile = true,
    fullscreen_state = "0 0",
    suppress_event = "fullscreen maximize",
})

-- Transparence pour toutes les fenêtres. La règle d'après gagne :
-- ajouter une classe ici pour la laisser opaque.
hl.window_rule({
    name = "default-transparency",
    match = { class = ".*" },
    opacity = "0.85 0.85",
})

hl.window_rule({
    match = { class = "^(google-chrome|chromium|steam|steam_app_.*)$" },
    opacity = "1 1",
})

-- Waytator
hl.window_rule({
    match = { class = "^(dev.faetalize.waytator)$" },
    float = true,
    center = true,
})

-- System Apps (Pavucontrol)
hl.window_rule({
    match = { class = "^(pavucontrol)$" },
    float = true,
    size = "(monitor_w*.45) (monitor_h*.45)",
    center = true,
})

-- Tiling & Special
hl.window_rule({
    match = { float = false },
    no_shadow = true,
})

-- Jetbrains Focus Fix
hl.window_rule({
    match = {
        class = "^jetbrains-.*$",
        float = true,
        title = "^$|^\\s$|^win\\d+$",
    },
    no_initial_focus = true,
})
