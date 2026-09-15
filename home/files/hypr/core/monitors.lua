-- Monitors Configuration
-- Fallback
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = 1,
})

-- Physical Monitors Layout
hl.monitor({
    output   = "desc:ASUSTek COMPUTER INC VY279HGE S7LMQS001610",
    mode     = "1920x1080@144",
    position = "0x0",
    scale    = 1,
    vrr      = 1,
})

hl.monitor({
    output   = "desc:ASUSTek COMPUTER INC VG2791R S3LMDW006158",
    mode     = "1920x1080@144",
    position = "1920x0",
    scale    = 1,
    vrr      = 1,
})

hl.monitor({
    output   = "eDP-1",
    mode     = "1920x1080@144",
    position = "3840x0",
    scale    = 1,
})

-- Fallback by port names
hl.monitor({
    output   = "DP-2",
    mode     = "1920x1080@144",
    position = "0x0",
    scale    = 1,
})

hl.monitor({
    output   = "DP-3",
    mode     = "1920x1080@144",
    position = "1920x0",
    scale    = 1,
})

hl.monitor({
    output   = "DP-4",
    mode     = "1920x1080@144",
    position = "1920x0",
    scale    = 1,
})
