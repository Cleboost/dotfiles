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

-- Transparency + Blur
local opacity_rules = {
    { class = "^(kitty)$", opacity = "0.85 0.85" },
    { class = "^(org.gnome.Nautilus)$", opacity = "0.85 0.85" },
    { class = "^(spotifast|fastpotify)$", opacity = "0.85 0.85" },
    { class = "^(discord)$", opacity = "0.85 0.85" },
    { class = "^(dev.zed.Zed)$", opacity = "0.85 0.85" },
    { class = "^(rustdesk)$", opacity = "0.85 0.85" },
    { class = "^(cursor)$", opacity = "0.85 0.85" },
    { class = "^(claude)$", opacity = "0.85 0.85" },
    { class = "^(dev.noctalia.Noctalia.Settings)$", opacity = "0.85 0.85" },
    { class = "^(obsidian)$", opacity = "0.85 0.85" },
    { class = "^(jetbrains-webstorm)$", opacity = "0.85 0.85" },
    { class = "^(jetbrains-rustrover)$", opacity = "0.85 0.85" },
    { class = "^(jetbrains-idea)$", opacity = "0.85 0.85" },
    { class = "^(jetbrains-clion)$", opacity = "0.85 0.85" },
    { class = "^(jetbrains-goland)$",               opacity = "0.85 0.85" }
}

for _, rule in ipairs(opacity_rules) do
    hl.window_rule({
        match = { class = rule.class },
        opacity = rule.opacity,
    })
end

-- Waytator
hl.window_rule({
    match = { class = "^(dev.faetalize.waytator)$" },
    opacity = "0.85 0.85",
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
