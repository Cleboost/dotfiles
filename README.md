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
├── flake.nix                  # Host list + flake inputs
├── modules/
│   └── cleboost/              # Shared options (cleboost.groups, …)
│
├── hosts/                     # Per-machine only
│   ├── cleboost-sage/
│   │   ├── profile.nix        # Package/feature groups for this host
│   │   ├── default.nix        # System (kernel, NVIDIA, Flipper, …)
│   │   ├── home.nix           # User overrides (extra packages, GPU stub, …)
│   │   ├── hardware-configuration.nix
│   │   ├── asus-fan-control.nix
│   │   └── gpu-env.nix        # PRIME / NVIDIA session vars (Hyprland)
│   └── cleboost-brain/
│       ├── profile.nix
│       ├── default.nix
│       ├── home.nix
│       └── hardware-configuration.nix
│
├── nixos/                     # Shared system config (all hosts)
│   ├── default.nix            # Nix, boot, locale, user, …
│   ├── desktop.nix  gaming.nix  docker.nix
│   ├── keyring.nix  noctalia.nix  packages.nix
│   └── nvidia.nix             # Imported only on NVIDIA hosts
│
└── home/                      # Shared user config (all hosts)
    ├── default.nix            # Entry point, imports host profile + packages
    ├── packages/
    │   ├── default.nix        # Imports group modules
    │   └── groups/            # One file per cleboost.groups entry
    ├── shell/                 # fish, git, starship, btop, fastfetch
    ├── kitty/
    ├── hyprland/
    ├── theme/                 # GTK, Qt, icons, cursor, wallpapers
    ├── apps/                  # MIME defaults, app configs (zed, noctalia, …)
    ├── secrets.nix            # gnome-keyring (user)
    └── bin/                   # Scripts → ~/.local/bin
```

## Package groups (`cleboost.groups`)

Hosts choose which **groups** are enabled in `hosts/<hostname>/profile.nix`. The option is defined in `modules/cleboost/default.nix` and is read by both **NixOS** (e.g. Steam when `gaming` is on) and **Home Manager** (user packages).

`profile.nix` is imported from:

- `hosts/<hostname>/default.nix` (system)
- `home/default.nix` via `../hosts/${hostName}/profile.nix` (user)

| Group | Home packages (`home/packages/groups/`) | NixOS (if any) |
| --- | --- | --- |
| `base-shell` | Wayland session tools (brightness, wl-clipboard, …) | — |
| `base-apps` | CLI toolbox + everyday apps (Chrome, Nautilus, Bitwarden, …) | — |
| `dev` | IDEs, AI tools, JDK, Node, Rust, … | — |
| `gui` | Lollypop, Obsidian, RustDesk, … | — |
| `social` | Telegram, Zapfast | — |
| `media` | mpv, feh, qBittorrent | — |
| `other` | Misc (e.g. Blockbench) | — |
| `gaming` | Launchers, MangoHud, gamescope, … | `nixos/gaming.nix` (Steam, GameMode, Ananicy) |

Hyprland, Noctalia shell/greeter, and dotfiles under `home/hyprland/` and `home/apps/` are **not** tied to groups today — they apply on every host that uses this `home/` tree.

Example — enable groups on the laptop:

```nix
# hosts/cleboost-sage/profile.nix
{
  cleboost.groups = [
    "base-shell"
    "base-apps"
    "dev"
    "gui"
    "social"
    "media"
    "other"
    "gaming"
  ];
}
```

A minimal host might use only `base-shell` + `base-apps` and skip `dev` / `gaming`.

**Important:** New files under `home/packages/groups/` must be **tracked by git** before `nix build` / `nh os switch` will see them (flake source filter).

## Where to change things

| Goal | Where |
| --- | --- |
| Add a package on **all hosts that use a group** | Edit the matching file in `home/packages/groups/<group>.nix` |
| Enable/disable a **set** of packages on a host | Edit `cleboost.groups` in `hosts/<hostname>/profile.nix` |
| Package on **one host only** | `home.packages` in `hosts/<hostname>/home.nix` |
| System service / Steam / Docker | `nixos/*.nix` (gaming module respects `gaming` in `cleboost.groups`) |
| System option on one host | `hosts/<hostname>/default.nix` (+ optional `imports`) |
| Program config (not the package itself) | Folder under `home/` (e.g. `home/hyprland/`, `home/apps/`) |
| Personal script | `home/bin/` |

Example — laptop-only package:

```nix
# hosts/cleboost-sage/home.nix
home.packages = with pkgs; [
  powertop
];
```

New host: add the name to `hosts` in `flake.nix`, then create `hosts/<name>/` with `profile.nix`, `default.nix`, `home.nix`, and `hardware-configuration.nix`.

## Usage

System hostname must match a flake entry (`cleboost-sage` or `cleboost-brain`).

```bash
nh os switch /home/cleboost/dotfiles
rebuild          # Home Manager (fast)
rebuild -s       # Full NixOS
```

Explicit build:

```bash
nix build .#nixosConfigurations.cleboost-sage.config.system.build.toplevel
```

## Migrate cleboost-sage (this PC)

1. `sudo hostnamectl set-hostname cleboost-sage`
2. `nh os switch /home/cleboost/dotfiles` (or `rebuild -s`)
3. Reboot if needed (greeter, network, …)

## Migrate cleboost-brain (new PC)

1. Install NixOS, clone this repo.
2. `sudo nixos-generate-config --show-hardware-config` → replace `hosts/cleboost-brain/hardware-configuration.nix`.
3. Edit `hosts/cleboost-brain/profile.nix` (which package groups).
4. Edit `hosts/cleboost-brain/default.nix` (GPU, disks, system imports, …).
5. Edit `hosts/cleboost-brain/home.nix` (GPU env stub, extra packages, …).
6. `sudo hostnamectl set-hostname cleboost-brain` then `nh os switch /home/cleboost/dotfiles`.

## Desktop stack (shared)

Hyprland, Noctalia, greetd, Kitty, Fish, `nixos-unstable` flake.

## License

Personal config — use at your own risk.
