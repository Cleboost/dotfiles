-- Personal Overrides (loaded last)

-- Autostart overrides
hl.on("hyprland.start", function()
    hl.exec_cmd("hyprpm reload -n")
    hl.exec_cmd("hyprctl setcursor cleboost-cursor 24")
end)

-- Border configuration
hl.config({
    general = {
        border_size = 6,
        col = {
            active_border = { colors = {"rgba(ffffff66)", "rgba(ffffff33)"}, angle = 135 },
            inactive_border = { colors = {"rgba(ffffff22)", "rgba(ffffff11)"}, angle = 135 },
        },
    },
})

-- Plugin configuration (only applied if loaded)
if hl.plugin["dynamic-cursors"] ~= nil then
    hl.config({
        plugin = {
            ["dynamic-cursors"] = {
                enabled = true,
                mode = "stretch",
                shake = {
                    enabled = true,
                    nearest = false,
                    base = 1.0,
                    speed = 4.0,
                    influence = 2.0,
                    limit = 3.0,
                    threshold = 3.0,
                    timeout = 1000,
                },
                hyprcursor = {
                    enabled = true,
                    resolution = 256,
                    fallback = "default",
                },
            },
        },
    })
end

-- Animation overrides
hl.curve("easeOutQuint", { type = "bezier", points = { {0.22, 1}, {0.36, 1} } })

hl.animation({ leaf = "windowsMove", enabled = true, speed = 4.0, bezier = "easeOutQuint", style = "slide" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 3.5, bezier = "easeOutQuint", style = "popin 5%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 3.5, bezier = "easeOutQuint", style = "popin 5%" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 4.5, bezier = "easeOutQuint", style = "slide" })

-- Unbinding mouse keys
hl.unbind("", "mouse:275")
hl.unbind("", "mouse:276")
hl.unbind("SUPER", "mouse:275")
hl.unbind("SUPER", "mouse:276")
hl.unbind("SUPER", "mouse_up")
hl.unbind("SUPER", "mouse_down")
hl.unbind("", "mouse_up")
hl.unbind("", "mouse_down")

-- Mouse Binds
hl.bind("mouse:275", hl.dsp.exec_cmd("playerctl previous"))
hl.bind("mouse:276", hl.dsp.exec_cmd("playerctl next"))

hl.bind("SUPER + mouse_up", hl.dsp.focus({ workspace = "e-1" }), { repeating = true })
hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "e+1" }), { repeating = true })
hl.bind("mouse_up", hl.dsp.focus({ workspace = "e-1" }), { repeating = true })
hl.bind("mouse_down", hl.dsp.focus({ workspace = "e+1" }), { repeating = true })
