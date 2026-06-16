-- Noctalia Shell & System Binds

-- Shell Toggles
hl.bind("SUPER + Super_L", hl.dsp.exec_cmd("noctalia msg panel-toggle launcher"))
hl.bind("SUPER + Super_R", hl.dsp.exec_cmd("noctalia msg panel-toggle launcher"))
hl.bind("CTRL + SUPER + T", hl.dsp.exec_cmd("noctalia msg panel-toggle wallpaper"))
hl.bind("SUPER + comma", hl.dsp.exec_cmd("noctalia msg settings-toggle"))
hl.bind("CTRL + ALT + Delete", hl.dsp.exec_cmd("noctalia msg panel-toggle session"))
hl.bind("SUPER + V", hl.dsp.exec_cmd("noctalia msg panel-toggle clipboard"), { desc = "Clipboard history" })
hl.bind("SUPER + semicolon", hl.dsp.exec_cmd("noctalia msg panel-toggle launcher \"/emo\""), { desc = "Emoji launcher" })

-- System Controls (Volume)
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("noctalia msg volume-up"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("noctalia msg volume-down"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("noctalia msg volume-mute"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("noctalia msg mic-mute"), { locked = true })

-- System Controls (Brightness)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("noctalia msg brightness-up"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("noctalia msg brightness-down"), { locked = true, repeating = true })

-- Power/Lock
hl.bind("SUPER + L", hl.dsp.exec_cmd("noctalia msg screen-lock"), { desc = "Lock Screen" })
hl.bind("SUPER + F5", hl.dsp.exec_cmd("noctalia msg power-cycle"))


-- Shell Management
hl.bind("CTRL + SUPER + ALT + R", hl.dsp.exec_cmd("pkill noctalia; pkill polkit-kde-auth; noctalia"), { desc = "Restart shell" })
hl.bind("CTRL + SHIFT + SUPER + ALT + R", hl.dsp.exec_cmd("pkill noctalia"), { desc = "Kill shell" })
hl.bind("CTRL + SUPER + ALT + T", hl.dsp.exec_cmd("noctalia msg wallpaper-random"))

hl.bind("SUPER + R", hl.dsp.exec_cmd("noctalia msg scripted-widget screen_recorder focused start"))
