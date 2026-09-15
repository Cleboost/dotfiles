-- Personal Overrides — loaded last, overrides everything including Noctalia theme

hl.on("hyprland.start", function()
    hl.exec_cmd("hyprctl setcursor cleboost-cursor 18")
end)

-- Glass-style borders — uniform semi-transparent, diagonal shimmer
hl.config({
    general = {
        border_size = 6,
        col = {
            active_border = { colors = { "rgba(ffffff66)", "rgba(ffffff33)" }, angle = 135 },
            inactive_border = { colors = { "rgba(ffffff22)", "rgba(ffffff11)" }, angle = 135 },
        },
    },
})

-- Smooth animations without overshoot / bounce
hl.curve("easeOutQuint", { type = "bezier", points = { {0.22, 1}, {0.36, 1} } })

hl.animation({ leaf = "windowsMove", enabled = true, speed = 4.0, bezier = "easeOutQuint", style = "slide" })
hl.animation({ leaf = "windowsIn",   enabled = true, speed = 3.5, bezier = "easeOutQuint", style = "popin 5%" })
hl.animation({ leaf = "windowsOut",  enabled = true, speed = 3.5, bezier = "easeOutQuint", style = "popin 5%" })
hl.animation({ leaf = "workspaces",  enabled = true, speed = 4.5, bezier = "easeOutQuint", style = "slide" })

-- Mouse Button Overrides
hl.unbind("mouse:275")
hl.unbind("mouse:276")
hl.unbind("SUPER + mouse:275")
hl.unbind("SUPER + mouse:276")
hl.unbind("SUPER + mouse_up")
hl.unbind("SUPER + mouse_down")
hl.unbind("mouse_up")
hl.unbind("mouse_down")

-- Scroll wheel with SUPER to switch workspaces
hl.bind("SUPER + mouse_up", hl.dsp.focus({ workspace = "e-1" }), { repeating = true })
hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "e+1" }), { repeating = true })
