# cleboost's NixOS dotfiles

Personal NixOS and Home Manager configuration for my daily driver, **cleboost-brain**.

This repo is not a generic template. It is tuned for my hardware, workflow, and preferences. Feel free to browse for ideas, but expect hard-coded paths, machine-specific settings, and opinionated defaults.

## Machine

- **Host:** `cleboost-brain` (`x86_64-linux`)
- **CPU:** AMD (with microcode updates)
- **GPU:** NVIDIA dGPU + AMD iGPU via **PRIME sync**
- **Displays:** laptop panel + dual 1080p144 external monitors (VRR/tearing enabled)
- **Storage:** root on ext4, dedicated `/mnt/games` SSD, zram swap (no disk swap)
- **Locale:** French (`fr_FR`), timezone `Europe/Paris`, AZERTY keyboard

## Desktop stack

| Layer | Tools |
| --- | --- |
| Compositor | [Hyprland](https://hyprland.org/) and [Umbriel](https://github.com/noctalia-dev/umbriel) (Noctalia compositor) |
| Shell / UI | [Noctalia](https://github.com/noctalia-dev/noctalia) bar, widgets, control center |
| Login | [Noctalia Greeter](https://github.com/noctalia-dev/noctalia-greeter) via greetd |
| Terminal | Kitty |
| Shell | Fish + Starship + direnv/nix-direnv |
| Theme | GTK Adwaita-dark, WhiteSur icons, custom cursor, Qt/Kvantum |

Both Hyprland and Umbriel configs live in this repo. Hyprland is the default greeter session; Umbriel is available as an alternative Wayland compositor with a matching modular TOML setup.

## Notable features

- **Flakes-based** NixOS + Home Manager setup (`nixos-unstable`)
- **Gaming:** Steam, GameMode, MangoHud, ananicy-cpp, Proton-GE, gamescope session
- **Dev tooling:** JDK, Maven, Gradle, Bun, Node.js, Rust, GCC
- **Apps:** Chrome, Discord, spotifast, Zed, Cursor, JetBrains IDEs, Bitwarden, and more
- **Custom scripts** in `home/files/bin/` (fastfetch helpers, JetBrains fix, SSH menu, etc.)
- **ASUS laptop extras:** fan control EC tool + Noctalia plugin integration

## Repo layout

```
.
├── flake.nix                 # Flake inputs and nixosConfigurations
├── configuration.nix         # Main system config
├── hardware-configuration.nix
├── modules/                  # System modules
│   ├── desktop.nix           # Hyprland, Umbriel, portals, AZERTY
│   ├── gaming.nix            # Steam, GameMode, ananicy
│   ├── nvidia.nix            # NVIDIA + AMD PRIME
│   ├── noctalia.nix          # Shell, greeter, ASUS fan control
│   └── packages.nix          # Fonts, system packages
└── home/                     # Home Manager config
    ├── default.nix
    ├── files/                # Dotfiles (hypr, umbriel, noctalia, kitty, etc.)
    └── modules/              # shell, hyprland, umbriel, apps, dev
```

## Flake inputs

Besides `nixpkgs` and `home-manager`, this config pulls in:

- `noctalia`, `noctalia-greeter`
- `chatgpt-desktop`, `codex-cli`

## Usage (on my machine)

This config uses **[NH](https://github.com/viperML/nh)** (`programs.nh` in `configuration.nix`, flake path `/home/cleboost/dotfiles`).

Scripts in `~/.local/bin` (from `home/files/bin/`):

```bash
rebuild          # Fast Home Manager-only switch (~seconds, no sudo)
rebuild -s       # Full NixOS switch via `nh os switch`
update           # `nh os switch -u` — update flake inputs + system switch
```

Equivalent NH commands:

```bash
nh os switch /home/cleboost/dotfiles
nh os switch -u /home/cleboost/dotfiles
```

The flake also exposes `nixosConfigurations.nixos` as an alias to `cleboost-brain`.

## License

Personal configuration. No license specified — use at your own risk.
