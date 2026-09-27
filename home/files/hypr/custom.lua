-- Personal overrides — loaded last, overrides everything including Noctalia theme

hl.on("hyprland.start", function()
    hl.exec_cmd("hyprctl setcursor cleboost-cursor 18")
end)

hl.config({
    general = {
        border_size = 6,
        col = {
            active_border = { colors = { "rgba(ffffff66)", "rgba(ffffff33)" }, angle = 135 },
            inactive_border = { colors = { "rgba(ffffff22)", "rgba(ffffff11)" }, angle = 135 },
        },
    },
})

hl.curve("easeOutQuint", { type = "bezier", points = { {0.22, 1}, {0.36, 1} } })

hl.animation({ leaf = "windowsMove", enabled = true, speed = 4.0, bezier = "easeOutQuint", style = "slide" })
hl.animation({ leaf = "windowsIn",   enabled = true, speed = 3.5, bezier = "easeOutQuint", style = "popin 5%" })
hl.animation({ leaf = "windowsOut",  enabled = true, speed = 3.5, bezier = "easeOutQuint", style = "popin 5%" })
hl.animation({ leaf = "workspaces",  enabled = true, speed = 4.5, bezier = "easeOutQuint", style = "slide" })
