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
│
├── hosts/                     # Per-machine only
│   ├── cleboost-sage/
│   │   ├── default.nix        # System (kernel, NVIDIA, Flipper, …)
│   │   ├── home.nix           # User (extra packages, …)
│   │   ├── hardware-configuration.nix
│   │   ├── asus-fan-control.nix
│   │   └── gpu-env.nix        # PRIME / NVIDIA session vars
│   └── cleboost-brain/
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
    ├── default.nix            # Entry point, XDG dirs
    ├── packages/              # Apps: gui, dev, cli, wayland
    ├── shell/                 # fish, git, starship, btop, fastfetch
    ├── kitty/
    ├── hyprland/
    ├── umbriel/
    ├── theme/                 # GTK, Qt, icons, cursor, wallpapers
    ├── apps/                  # Default apps (MIME) + zed, noctalia, mangohud, …
    ├── secrets.nix            # gnome-keyring (user)
    └── bin/                   # Scripts → ~/.local/bin
```

## Where to change things

| Goal | File |
| --- | --- |
| App on every host | `home/packages/gui.nix` (or `dev`, `cli`, `wayland`) |
| App on one host only | `home.packages` in `hosts/<hostname>/home.nix` |
| System option everywhere | `nixos/default.nix` or the matching module |
| System option on one host | `hosts/<hostname>/default.nix` |
| Program config | its folder under `home/` (e.g. `home/hyprland/`) |
| Personal script | `home/bin/` |

Example — laptop-only package:

```nix
# hosts/cleboost-sage/home.nix
home.packages = with pkgs; [
  scrcpy
];
```

New host: add the name to `hosts` in `flake.nix`, then create `hosts/<name>/` with `default.nix`, `home.nix`, and `hardware-configuration.nix`.

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
3. Edit `hosts/cleboost-brain/default.nix` (GPU, disks, system packages, …).
4. Edit `hosts/cleboost-brain/home.nix` (GPU env, apps, …).
5. `sudo hostnamectl set-hostname cleboost-brain` then `nh os switch /home/cleboost/dotfiles`.

## Desktop stack (shared)

Hyprland + Umbriel, Noctalia, greetd, Kitty, Fish, `nixos-unstable` flake.

## License

Personal config — use at your own risk.
