# cleboost's NixOS dotfiles

One repo, three folders. Desktops/laptops on **nixos-unstable**, production VPS on **nixos-26.05**.

| Host | Channel | Role |
| --- | --- | --- |
| **cleboost-sage** | unstable | Laptop (AMD + NVIDIA PRIME, ASUS fans, Flipper, …) |
| **cleboost-brain** | unstable | Desktop (Ryzen 5950X, Titan X Pascal) |
| **vps-assosite** | 26.05 stable | Production VPS (Docker, Dokploy) |

## Layout

```
flake.nix                 # machines + flake outputs (required by Nix)
hosts/<hostname>/         # per-machine hardware and system config
home/                     # apps, groups, configs, per-machine variants
system/                   # shared NixOS: boot, network, services, drivers
```

### `hosts/` — hardware & system

```
hosts/cleboost-brain/
  default.nix               # drivers, kernel, network, hostname
  hardware-configuration.nix
  storage.nix               # extra drives (brain)
  ugreen-wifi.nix           # Wi-Fi dongle (brain)
```

**App groups** (`cleboost.groups`) live in `home/hosts/<hostname>/groups.nix` and are imported by the NixOS host.

### `home/` — your main workspace

```
home/
  default.nix               # Home Manager entry point
  groups/                   # one .nix per group (packages + config link)
  config/                   # app configs (hyprland, noctalia, kitty, …)
  hosts/<hostname>/         # HM variants + groups
  pkgs/                     # custom packages (pdfcraft, codex, …)
  assets/wallpapers/
```

### `system/` — shared NixOS

```
system/
  default.nix               # boot, locale, nh, earlyoom, …
  server/                   # headless variant (VPS)
  options.nix               # cleboost.groups, cleboost.hypr, …
  services/                 # docker, gaming, noctalia, keyring
  drivers/                  # nvidia, amdgpu, intel, asus, vm
  pkgs/                     # out-of-tree drivers (aic8800, …)
```

## Package groups (`cleboost.groups`)

Defined in `home/hosts/<hostname>/groups.nix`. The same active list:

| Layer | Path |
| --- | --- |
| Packages + config link | `home/groups/<group>.nix` |
| NixOS (Steam, GameMode) | `system/services/gaming.nix` if `gaming` |

| Group | Packages | Config (examples) |
| --- | --- | --- |
| `base-shell` | Wayland CLI tools | — |
| `base-apps` | Chrome, Nautilus, Bitwarden, … | MIME, Nautilus, Hypr autostart |
| `dev` | IDEs, SDKs | Zed |
| `ia` | Cursor, Claude, Codex, Rakazo, … | Antigravity CLI seed |
| `gui` | Obsidian, RustDesk, scrcpy | — |
| `social` | Telegram, Zapfast, Discord | Zapfast settings |
| `media` | mpv, qBittorrent, Lollypop | MIME, qBittorrent theme |
| `other` | Blockbench, Blender | — |
| `gaming` | MangoHud, launchers | BeamNG cheat menu, Hypr rules |

**Always active**: `home/config/` (shell, Hyprland, Kitty, theme, Noctalia, WirePlumber).

MIME: `xdg.mimeApps.enable` in `home/groups/module.nix`.

New paths must be **git-tracked** before `nix build` / `nh os switch`.

## Where to change things

| Goal | Where |
| --- | --- |
| Packages in a group | `home/groups/<group>.nix` |
| App config | `home/config/<app>/` |
| Enable groups on a machine | `home/hosts/<hostname>/groups.nix` |
| Hardware, drivers, kernel | `hosts/<hostname>/default.nix` |
| Per-machine HM packages | `home/hosts/<hostname>/home.nix` |
| Per-machine Hyprland / Noctalia | `home/config/hyprland/hosts/`, `home/config/noctalia/hosts/` |
| Shared system | `system/` |
| Drivers | `system/drivers/` |

## cleboost-brain vs cleboost-sage

**Brain** (tower): `cleboost.hypr.dynamicWorkspaces = false`, Titan X on `legacy_580`, `nvidia-gaming` game boost (100% fan toggle + 300 W PL), `/mnt/games` and `/mnt/data` drives via `storage.nix`, UGREEN Wi-Fi via `ugreen-wifi.nix`.

**Sage** (laptop): NVIDIA PRIME, ASUS fans, Flipper Zero, `cleboost.gaming.gpuDevice = 1`.

Noctalia, fonts, icons and wallpapers. Unlike the laptop configuration, the brain bar layout is in `home/config/noctalia/hosts/cleboost-brain.nix`.

## Commands

```bash
# Switch (from repo)
sudo nh os switch .

# Dry-run
nix build .#nixosConfigurations.cleboost-brain.config.system.build.toplevel --dry-run
```
