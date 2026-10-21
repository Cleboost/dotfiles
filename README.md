# cleboost's NixOS dotfiles

One repo, three folders. Multiple NixOS hosts + Home Manager.

| Host | Role |
| --- | --- |
| **cleboost-sage** | Laptop (AMD + NVIDIA PRIME, ASUS fans, Flipper, …) |
| **cleboost-brain** | Desktop (Ryzen 5950X, Titan X Pascal) |
| **cleboost-demo** | Generic full desktop for an installed NixOS demo PC |
| **cleboost-demo-live** | Disposable bootable ISO/USB |

## Layout

```
flake.nix                 # machines + outputs flake (obligatoire Nix)
hosts/<hostname>/         # matériel et système par machine
home/                     # apps, groupes, configs, variantes par machine
system/                   # NixOS commun : boot, réseau, services, drivers
```

### `hosts/` — matériel & système

```
hosts/cleboost-brain/
  default.nix               # drivers, kernel, réseau, hostname
  hardware-configuration.nix
  storage.nix               # disques extra (brain)
  ugreen-wifi.nix           # dongle Wi-Fi (brain)
```

Les **groupes d'apps** (`cleboost.groups`) vivent dans `home/hosts/<hostname>/groups.nix` et sont importés par le host NixOS.

### `home/` — ton espace principal

```
home/
  default.nix               # entrée Home Manager
  groups/                   # un .nix par groupe (paquets + lien config)
  config/                   # configs app (hyprland, noctalia, kitty, …)
  hosts/<hostname>/         # variantes HM + groupes
  pkgs/                     # paquets custom (pdfcraft, codex, …)
  assets/wallpapers/
```

### `system/` — NixOS partagé

```
system/
  default.nix               # boot, locale, nh, earlyoom, …
  options.nix               # cleboost.groups, cleboost.hypr, …
  services/                 # docker, gaming, noctalia, keyring
  drivers/                  # nvidia, amdgpu, intel, asus, vm
  pkgs/                     # drivers out-of-tree (aic8800, …)
  scripts/                  # install-demo.sh
```

## Package groups (`cleboost.groups`)

Définis dans `home/hosts/<hostname>/groups.nix`. La même liste active :

| Couche | Chemin |
| --- | --- |
| Paquets + lien config | `home/groups/<groupe>.nix` |
| NixOS (Steam, GameMode) | `system/services/gaming.nix` si `gaming` |

| Group | Packages | Config (exemples) |
| --- | --- | --- |
| `base-shell` | Wayland CLI tools | — |
| `base-apps` | Chrome, Nautilus, Bitwarden, … | MIME, Nautilus, Hypr autostart |
| `dev` | IDEs, SDKs | Zed |
| `ia` | Cursor, Claude, Codex, … | Antigravity CLI seed |
| `gui` | Obsidian, RustDesk, scrcpy | — |
| `social` | Telegram, Zapfast, Discord | Zapfast settings |
| `media` | mpv, qBittorrent, Lollypop | MIME, thème qBittorrent |
| `other` | Blockbench, Blender | — |
| `gaming` | MangoHud, launchers | BeamNG cheat menu, Hypr rules |

**Toujours actif** : `home/config/` (shell, Hyprland, Kitty, thème, Noctalia, WirePlumber).

MIME : `xdg.mimeApps.enable` dans `home/groups/module.nix`.

Nouveaux chemins doivent être **git-trackés** avant `nix build` / `nh os switch`.

## Where to change things

| Goal | Where |
| --- | --- |
| Paquets d'un groupe | `home/groups/<groupe>.nix` |
| Config d'une app | `home/config/<app>/` |
| Activer des groupes sur un PC | `home/hosts/<hostname>/groups.nix` |
| Matériel, drivers, kernel | `hosts/<hostname>/default.nix` |
| Paquets HM par machine | `home/hosts/<hostname>/home.nix` |
| Hyprland / Noctalia par machine | `home/config/hyprland/hosts/`, `home/config/noctalia/hosts/` |
| Système commun | `system/` |
| Drivers | `system/drivers/` |

## cleboost-brain vs cleboost-sage

**Brain** (tower) : `cleboost.hypr.dynamicWorkspaces = false`, Titan X en `legacy_580`, disques `/mnt/games` et `/mnt/data` via `storage.nix`, Wi-Fi UGREEN via `ugreen-wifi.nix`.

**Sage** (laptop) : NVIDIA PRIME, ventilateurs ASUS, Flipper Zero, `cleboost.gaming.gpuDevice = 1`.

Noctalia, fonts, icons and wallpapers. Unlike the laptop configuration, the brain bar layout is in `home/config/noctalia/hosts/cleboost-brain.nix`.

## Demo ISO / portable install

Build ISO:

```bash
nix build .#packages.x86_64-linux.demo-iso
```

Install demo config on an existing NixOS (no partitioning):

```bash
bash system/scripts/install-demo.sh --apply
```

Live ISO uses `system/demo-live.nix` (no `hardware-configuration.nix`).

## Commands

```bash
# Switch (from repo)
sudo nh os switch .

# Dry-run
nix build .#nixosConfigurations.cleboost-brain.config.system.build.toplevel --dry-run
```
