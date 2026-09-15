-- Workspace Navigation & Window Movement

local function get_target_workspace(num)
    local curr = hl.get_active_workspace()
    local curr_id = curr and curr.id or 1
    return math.floor((curr_id - 1) / 10) * 10 + num
end

-- Number Keys (Focus)
for i = 1, 10 do
    local code = 9 + i
    hl.bind("SUPER + code:" .. code, function()
        hl.dispatch(hl.dsp.focus({ workspace = get_target_workspace(i) }))
    end)
end

-- Keypad (Focus)
local keypad_codes = { 87, 88, 89, 83, 84, 85, 79, 80, 81, 90 }
for i, code in ipairs(keypad_codes) do
    hl.bind("SUPER + code:" .. code, function()
        hl.dispatch(hl.dsp.focus({ workspace = get_target_workspace(i) }))
    end, { locked = true })
end

-- Directional & Mouse (Focus)
hl.bind("CTRL + SUPER + Right", hl.dsp.focus({ workspace = "r+1" }))
hl.bind("CTRL + SUPER + Left", hl.dsp.focus({ workspace = "r-1" }))
hl.bind("SUPER + Page_Down", hl.dsp.focus({ workspace = "+1" }))
hl.bind("SUPER + Page_Up", hl.dsp.focus({ workspace = "-1" }))
hl.bind("SUPER + mouse_up", hl.dsp.focus({ workspace = "r+1" }))
hl.bind("SUPER + mouse_down", hl.dsp.focus({ workspace = "r-1" }))
hl.bind("CTRL + SUPER + mouse_up", hl.dsp.focus({ workspace = "r+1" }))
hl.bind("CTRL + SUPER + mouse_down", hl.dsp.focus({ workspace = "r-1" }))

-- Number Keys (Move Windows Silent)
for i = 1, 10 do
    local code = 9 + i
    hl.bind("SUPER + ALT + code:" .. code, function()
        hl.dispatch(hl.dsp.window.move({ workspace = get_target_workspace(i), follow = false }))
    end)
end

-- Directional & Mouse (Move Windows)
hl.bind("SUPER + SHIFT + mouse_down", hl.dsp.window.move({ workspace = "r-1" }))
hl.bind("SUPER + SHIFT + mouse_up", hl.dsp.window.move({ workspace = "r+1" }))
hl.bind("SUPER + ALT + mouse_down", hl.dsp.window.move({ workspace = "-1" }))
hl.bind("SUPER + ALT + mouse_up", hl.dsp.window.move({ workspace = "+1" }))
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
hl.bind("CTRL + SUPER + bracketleft", hl.dsp.focus({ workspace = "-1" }))
hl.bind("CTRL + SUPER + bracketright", hl.dsp.focus({ workspace = "+1" }))

-- Workspace Reorganization (Force Refresh)
hl.bind("SUPER + SHIFT + W", hl.dsp.exec_cmd("~/.config/hypr/scripts/manage_workspaces.sh --once"), { desc = "Réorganiser les workspaces" })
