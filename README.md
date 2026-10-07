# cleboost's NixOS dotfiles

One repo, multiple NixOS hosts + Home Manager.

| Host | Role |
| --- | --- |
| **cleboost-sage** | Current laptop (AMD + NVIDIA PRIME, ASUS fans, Flipper, …) |
| **cleboost-brain** | Future desktop (hardware config generated at install) |

## Layout

Each `.nix` file lives next to the config files it deploys.

```
.
├── flake.nix
├── modules/cleboost/          # Shared options (cleboost.groups)
│
├── hosts/<hostname>/
│   ├── profile.nix            # cleboost.groups for this machine
│   ├── default.nix            # NixOS overrides
│   ├── home.nix               # HM overrides (extra packages, GPU stub)
│   └── hardware-configuration.nix
│
├── nixos/                     # Shared system config
│
└── home/
    ├── default.nix            # HM entry (thin)
    ├── bin/                   # Scripts → ~/.local/bin
    ├── groups/                # One folder per cleboost.groups (packages + dotfiles)
    │   ├── base-apps/
    │   ├── dev/
    │   └── …
    └── modules/
        ├── session.nix        # XDG dirs, ~/.local/bin
        ├── common/            # shell, secrets (always)
        └── desktop/           # Hyprland, Kitty, theme, Noctalia, WirePlumber
```

## Package groups (`cleboost.groups`)

Defined in `hosts/<hostname>/profile.nix`. Same list drives:

| Layer | Path |
| --- | --- |
| **Packages + dotfiles** | `home/groups/<group>/default.nix` (+ assets in same folder) |
| **NixOS** (e.g. Steam) | `nixos/gaming.nix` when group is `gaming` |

| Group | Packages | Dotfiles (examples) |
| --- | --- | --- |
| `base-shell` | Wayland CLI tools | — |
| `base-apps` | Chrome, Nautilus, Bitwarden, CLI, … | MIME web/files, Nautilus `.mo`, Hypr autostart |
| `dev` | IDEs, SDKs, AI CLIs | Zed settings, Cursor `.desktop`, JetBrains MIME |
| `gui` | Obsidian, RustDesk, scrcpy, … | — |
| `social` | Telegram, Zapfast, Discord, Spotifast | Discord MIME, Hypr autostart |
| `media` | mpv, feh, qBittorrent, Evince, Lollypop | MIME audio/video/PDF/images, qBittorrent theme |
| `other` | Blockbench | — |
| `gaming` | MangoHud, launchers, … | MangoHud conf, Hypr rules & Steam autostart |

**Always on** (not gated by groups): `home/modules/common/` (Fish, Starship, keyring), `home/modules/desktop/` (Hyprland, Kitty, theme, Noctalia, WirePlumber). Hypr autostart scripts are generated from `cleboost.groups` via `hypr/autostart/_groups.lua`.

MIME: `xdg.mimeApps.enable` is set once in `home/groups/default.nix`; each group only adds `defaultApplications` entries.

New paths under `home/` must be **git-tracked** before `nix build` / `nh os switch`.

## Where to change things

| Goal | Where |
| --- | --- |
| Add **packages or config** for a group | `home/groups/<group>/` |
| Enable/disable a group on a host | `hosts/<hostname>/profile.nix` |
| Package on **one host only** | `hosts/<hostname>/home.nix` → `home.packages` |
| Hyprland / session (shared) | `home/modules/desktop/hyprland/` |
| System (Steam, Docker, …) | `nixos/*.nix` |
| Personal script | `home/bin/` |

## Usage

```bash
nh os switch /home/cleboost/dotfiles
rebuild          # Home Manager only
rebuild -s       # Full NixOS
```

Hostname must match flake host (`cleboost-sage` or `cleboost-brain`).

## Desktop stack

Hyprland, Noctalia (bar + greeter on NixOS), Kitty, Fish, `nixos-unstable`.

## Migrate cleboost-sage

1. `sudo hostnamectl set-hostname cleboost-sage`
2. `nh os switch /home/cleboost/dotfiles` (or `rebuild -s`)
3. Reboot if needed

## Migrate cleboost-brain

1. Install NixOS, clone repo.
2. `sudo nixos-generate-config --show-hardware-config` → `hosts/cleboost-brain/hardware-configuration.nix`
3. Edit `profile.nix`, `default.nix`, `home.nix`
4. `sudo hostnamectl set-hostname cleboost-brain` then `nh os switch`

## License

Personal config — use at your own risk.
