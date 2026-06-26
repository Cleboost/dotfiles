-- Window & Layer Rules

hl.window_rule({ match = { title = "^(Open File)(.*)$" }, float = true, center = true })
hl.window_rule({ match = { title = "^(Select a File)(.*)$" }, float = true, center = true })
hl.window_rule({ match = { title = "^(Open Folder)(.*)$" }, float = true, center = true })
hl.window_rule({ match = { title = "^(Save As)(.*)$" }, float = true, center = true })

hl.window_rule({ match = { class = "^(chrome-nngceckbapebfimnlniiiahkandclblb-Default)$" }, float = true, size = "400 600" })

hl.window_rule({ match = { class = "^(org.gnome.Nautilus)$" }, opacity = "0.85 0.85" })
hl.window_rule({ match = { class = "^(ncspot)$" }, opacity = "0.85 0.85" })
hl.window_rule({ match = { class = "^(discord)$" }, opacity = "0.85 0.85" })

hl.window_rule({ match = { class = "^(dev.zed.Zed)$" }, opacity = "0.85 0.85" })
hl.window_rule({ match = { class = "^(rustdesk)$" }, opacity = "0.85 0.85" })
hl.window_rule({ match = { class = "^(cursor)$" }, opacity = "0.85 0.85" })
hl.window_rule({ match = { class = "^(claude)$" }, opacity = "0.85 0.85" })
hl.window_rule({ match = { class = "^(dev.noctalia.Noctalia.Settings)$" }, opacity = "0.85 0.85" })
hl.window_rule({ match = { class = "^(dev.faetalize.waytator)$" }, opacity = "0.85 0.85", float = true, center = true })
hl.window_rule({ match = { class = "^(ssh-menu)$" }, float = true, size = "600 400", center = true, opacity = "0.90 0.90" })

hl.window_rule({ match = { class = "^(pavucontrol)$" }, float = true, size = "(monitor_w*.45) (monitor_h*.45)", center = true })

hl.window_rule({ match = { class = "^dev\\.warp\\.Warp$" }, tile = true })
hl.window_rule({ match = { float = false }, no_shadow = true })

hl.window_rule({ match = { title = ".*\\.exe" }, immediate = true })
hl.window_rule({ match = { title = ".*minecraft.*" }, immediate = true })
hl.window_rule({ match = { class = "^(steam_app).*" }, immediate = true })

hl.window_rule({ match = { class = "^jetbrains-.*$", float = true, title = "^$|^\\s$|^win\\d+$" }, no_initial_focus = true })

hl.window_rule({ match = { class = "^(jetbrains-webstorm)$" }, opacity = "0.85 0.85" })
hl.window_rule({ match = { class = "^(jetbrains-rustrover)$" }, opacity = "0.85 0.85" })
hl.window_rule({ match = { class = "^(jetbrains-idea)$" }, opacity = "0.85 0.85" })
hl.window_rule({ match = { class = "^(jetbrains-clion)$" }, opacity = "0.85 0.85" })
hl.window_rule({ match = { class = "^(jetbrains-goland)$" }, opacity = "0.85 0.85" })
hl.window_rule({ match = { class = "^(obsidian)$" }, opacity = "0.85 0.85" })
