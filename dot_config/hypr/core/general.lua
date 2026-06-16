-- General Configuration

-- Load dynamic-cursors plugin at parsing time so its configuration variables are registered
hl.plugin.load("/var/cache/hyprpm/cleboost/dynamic-cursors/dynamic-cursors.so")

hl.config({
    general = {
        gaps_in = 4,
        gaps_out = 8,
        gaps_workspaces = 50,
        border_size = 6,
        resize_on_border = true,
        no_focus_fallback = true,
        allow_tearing = true,
        snap = {
            enabled = true,
            window_gap = 4,
            monitor_gap = 5,
            respect_gaps = true,
        },
        col = {
            active_border = { colors = {"rgba(ffffff66)", "rgba(ffffff33)"}, angle = 135 },
            inactive_border = { colors = {"rgba(ffffff22)", "rgba(ffffff11)"}, angle = 135 },
        },
    },
    dwindle = {
        preserve_split = true,
        smart_split = false,
        smart_resizing = false,
    },
    input = {
        kb_layout = "fr,us",
        numlock_by_default = true,
        repeat_delay = 250,
        repeat_rate = 35,
        follow_mouse = 1,
        off_window_axis_events = 2,
        touchpad = {
            natural_scroll = true,
            disable_while_typing = true,
            clickfinger_behavior = true,
            scroll_factor = 0.7,
        },
    },
    decoration = {
        rounding_power = 2.4,
        rounding = 18,
        blur = {
            enabled = true,
            xray = true,
            special = true,
            new_optimizations = true,
            size = 10,
            passes = 3,
            brightness = 1,
            noise = 0.04,
            contrast = 0.9,
            vibrancy = 0.56,
            vibrancy_darkness = 0.48,
            popups = false,
            popups_ignorealpha = 0.6,
            input_methods = true,
            input_methods_ignorealpha = 0.8,
        },
        shadow = {
            enabled = true,
            range = 50,
            offset = { 0, 4 },
            render_power = 10,
            color = "rgba(00000027)",
        },
        dim_inactive = true,
        dim_strength = 0.05,
        dim_special = 0.07,
    },
    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        vrr = 1,
        mouse_move_enables_dpms = true,
        key_press_enables_dpms = true,
        animate_manual_resizes = false,
        animate_mouse_windowdragging = false,
        enable_swallow = false,
        on_focus_under_fullscreen = 2,
        allow_session_lock_restore = true,
        initial_workspace_tracking = false,
        focus_on_activate = false,
        background_color = "rgba(131314FF)",
    },
    binds = {
        scroll_event_delay = 0,
        hide_special_on_workspace_change = true,
    },
    cursor = {
        no_hardware_cursors = true,
        zoom_factor = 1,
        zoom_rigid = false,
        hotspot_padding = 1,
    },
    debug = {
        vfr = 1,
    },
    plugin = {
        dynamic_cursors = {
            enabled = true,
            mode = "stretch",
            shake = {
                enabled = true,
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

-- Curves & Bezier
hl.curve("easeOutQuint", { type = "bezier", points = { {0.22, 1}, {0.36, 1} } })
hl.curve("easeOutBack", { type = "bezier", points = { {0.34, 1.56}, {0.64, 1} } })
hl.curve("expressiveFastSpatial", { type = "bezier", points = { {0.42, 1.67}, {0.21, 0.90} } })
hl.curve("expressiveSlowSpatial", { type = "bezier", points = { {0.39, 1.29}, {0.35, 0.98} } })
hl.curve("expressiveDefaultSpatial", { type = "bezier", points = { {0.38, 1.21}, {0.22, 1.00} } })
hl.curve("emphasizedDecel", { type = "bezier", points = { {0.05, 0.7}, {0.1, 1} } })
hl.curve("emphasizedAccel", { type = "bezier", points = { {0.3, 0}, {0.8, 0.15} } })
hl.curve("standardDecel", { type = "bezier", points = { {0, 0}, {0, 1} } })
hl.curve("menu_decel", { type = "bezier", points = { {0.1, 1}, {0, 1} } })
hl.curve("menu_accel", { type = "bezier", points = { {0.52, 0.03}, {0.72, 0.08} } })
hl.curve("stall", { type = "bezier", points = { {1, -0.1}, {0.7, 0.85} } })

-- Animations
hl.animation({ leaf = "windowsIn", enabled = true, speed = 3.8, bezier = "easeOutBack", style = "popin 40%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 3, bezier = "emphasizedDecel" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 3.8, bezier = "easeOutBack", style = "popin 40%" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 2, bezier = "emphasizedDecel" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 4.0, bezier = "easeOutQuint", style = "slide" })
hl.animation({ leaf = "border", enabled = true, speed = 10, bezier = "emphasizedDecel" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 2.7, bezier = "emphasizedDecel", style = "popin 93%" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 2.4, bezier = "menu_accel", style = "popin 94%" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 0.5, bezier = "menu_decel" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 2.7, bezier = "stall" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 3.5, bezier = "easeOutQuint", style = "slide" })
hl.animation({ leaf = "specialWorkspaceIn", enabled = true, speed = 2.8, bezier = "emphasizedDecel", style = "slidevert" })
hl.animation({ leaf = "specialWorkspaceOut", enabled = true, speed = 1.2, bezier = "emphasizedAccel", style = "slidevert" })

-- Gestures & Actions
hl.gesture({ fingers = 4, direction = "horizontal", action = "workspace" })
hl.gesture({ fingers = 4, direction = "up", action = function() hl.exec_cmd("noctalia msg panel-toggle launcher") end })
hl.gesture({ fingers = 4, direction = "down", action = function() hl.exec_cmd("noctalia msg panel-toggle session") end })

-- Startup apps
hl.on("hyprland.start", function()
    hl.exec_cmd("hyprctl setcursor cleboost-cursor 24")
    hl.exec_cmd("noctalia")
    hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")
    hl.exec_cmd("systemctl --user import-environment XDG_SESSION_CLASS WAYLAND_DISPLAY DISPLAY")
    hl.exec_cmd("systemctl --user start localsearch-3.service")
    hl.exec_cmd("sleep 2 && nautilus --gapplication-service")
    hl.exec_cmd("steam -silent")
    hl.exec_cmd("jetbrain-fix")
    hl.exec_cmd("~/.config/hypr/scripts/manage_workspaces.sh")
    hl.exec_cmd("~/.config/hypr/scripts/bitwarden-float.sh")
    hl.exec_cmd("[workspace 1 silent] google-chrome-stable")
end)
