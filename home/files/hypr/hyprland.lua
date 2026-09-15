-- Hyprland Main Lua Configuration
-- Reference: https://hypr.land/news/26_lua/ and https://wiki.hypr.land/configuring/

local home = os.getenv("HOME") or "/home/cleboost"
package.path = table.concat({
    home .. "/.config/hypr/?.lua",
    home .. "/.config/hypr/?/init.lua",
    package.path,
}, ";")

-- ── Core ──────────────────────────────────────────────────────────────────────
require("gpu-env")
require("core.env")
require("core.execs")
require("core.general")
require("core.monitors")
pcall(require, "workspaces")

-- ── Appearance ────────────────────────────────────────────────────────────────
require("theme.colors")

-- ── Binds ─────────────────────────────────────────────────────────────────────
require("binds.noctalia")
require("binds.workspaces")
require("binds.keybinds")

-- ── Rules ─────────────────────────────────────────────────────────────────────
require("rules.rules")
require("rules.specialwork")

-- ── Noctalia Managed ──────────────────────────────────────────────────────────
-- Noctalia renders dynamic colors to ~/.config/hypr/noctalia.lua
pcall(function()
    require("noctalia").apply_theme()
end)

-- ── Personal Overrides ────────────────────────────────────────────────────────
require("custom")
