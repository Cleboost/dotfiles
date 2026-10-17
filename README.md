# cleboost's NixOS dotfiles

One repo, multiple NixOS hosts + Home Manager.

| Host | Role |
| --- | --- |
| **cleboost-sage** | Current laptop (AMD + NVIDIA PRIME, ASUS fans, Flipper, …) |
| **cleboost-brain** | Primary desktop (Ryzen 5950X, Titan X Pascal, ASUS board) |
| **cleboost-demo** | Generic full desktop for an installed NixOS demo PC |
| **cleboost-demo-live** | Disposable, bootable ISO/USB: no target disk installation |

## Layout

```
flake.nix                      # liste des machines, rien d'autre
hosts/<hostname>/
  default.nix                  # boutons NixOS : groupes, drivers, hostname
  hardware-configuration.nix
  home.nix                     # paquets en plus pour ce PC
  gpu-env.nix                  # si le GPU a besoin d'un env
  hypr.nix                     # écrans / workspaces, seulement si différent
  noctalia.nix                 # diff Noctalia, seulement si différent
modules/core/                  # système commun
modules/drivers/               # nvidia, amd, intel, asus, vm
modules/home/
  default.nix                  # entrée Home Manager
  shell/  desktop/  apps/<groupe>/
pkgs/                          # paquets locaux
```

Un PC sans `noctalia.nix` utilise `modules/home/desktop/noctalia/settings.nix` (sage).
Un PC sans `hypr.nix` utilise les écrans partagés.

## Package groups (`cleboost.groups`)

Définis dans `hosts/<hostname>/default.nix`. La même liste active :

| Couche | Chemin |
| --- | --- |
| Paquets + fichiers | `modules/home/apps/<groupe>/` |
| NixOS (Steam, GameMode) | `modules/core/services/gaming.nix` si `gaming` |

| Group | Packages | Dotfiles (examples) |
| --- | --- | --- |
| `base-shell` | Wayland CLI tools | — |
| `base-apps` | Chrome, Nautilus, Bitwarden, CLI, … | MIME web/files, Nautilus `.mo`, Hypr autostart |
| `dev` | IDEs, SDKs | Zed settings, JetBrains MIME |
| `ia` | Cursor, Claude Desktop, Codex, Antigravity, ChatGPT desktop, Grok bot | Antigravity CLI seed (Cursor ACL disabled) |
| `gui` | Obsidian, RustDesk, scrcpy, … | — |
| `social` | Telegram, Zapfast, Discord, Spotifast | Discord MIME, Hypr autostart |
| `media` | mpv, feh, qBittorrent, PdfCraft, Lollypop | MIME audio/video/PDF/images, qBittorrent theme |
| `other` | Blockbench | — |
| `gaming` | MangoHud, launchers, … | MangoHud conf, Hypr rules & Steam autostart |

**Always on** (not gated by groups): `modules/home/shell/` (Fish, Starship, Git, secrets), `modules/home/desktop/` (Hyprland, Kitty, theme, Noctalia, WirePlumber). Hypr autostart scripts are generated from `cleboost.groups` via `hypr/autostart/_groups.lua`.

MIME: `xdg.mimeApps.enable` is set once in `modules/home/apps/default.nix`; each app category only adds `defaultApplications` entries.

New paths must be **git-tracked** before `nix build` / `nh os switch`.

## Where to change things

| Goal | Where |
| --- | --- |
| Paquets ou config d’un groupe | `modules/home/apps/<groupe>/` |
| Activer un groupe, un driver, le hostname | `hosts/<hostname>/default.nix` |
| Paquet sur un seul PC | `hosts/<hostname>/home.nix` |
| Écrans / workspaces d’un PC | `hosts/<hostname>/hypr.nix` |
| Hyprland, thème, kitty, noctalia partagés | `modules/home/desktop/` |
| Noctalia d’un PC | `hosts/<hostname>/noctalia.nix` |
| Disques extra (brain) | `hosts/cleboost-brain/storage.nix` → `/mnt/games`, `/mnt/data` |
| Shell, git, secrets | `modules/home/shell/` |
| Système | `modules/core/` |
| Drivers | `modules/drivers/` |

## Usage

```bash
nh os switch /home/cleboost/dotfiles
```

Hostname must match flake host (`cleboost-sage`, `cleboost-brain`, or `cleboost-demo`).

## Desktop stack

Hyprland, Noctalia (bar + greeter on NixOS), Kitty, Fish, `nixos-unstable`.

## Migrate cleboost-sage

1. `sudo hostnamectl set-hostname cleboost-sage`
2. `nh os switch /home/cleboost/dotfiles`
3. Reboot if needed

## Migrate cleboost-brain

1. Install NixOS, clone repo.
2. `sudo nixos-generate-config --show-hardware-config` → `hosts/cleboost-brain/hardware-configuration.nix`
3. Edit `default.nix` and `home.nix`
4. `sudo hostnamectl set-hostname cleboost-brain` then `nh os switch`

## Portable demo: same desktop on other hardware

The portable demo reuses **all eight app groups**, Home Manager, Hyprland,
Noctalia, fonts, icons and wallpapers. Unlike the laptop configuration, the
demo has **no hard-coded NVIDIA PRIME PCI bus IDs, monitor names, ASUS fan
drivers, or laptop keyboard device path**. Monitor resolution/position is
autodetected. The Noctalia fan widget and laptop-specific plugins are omitted;
fixed desktop widgets are disabled because they were pinned to `DP-2`.
Discord/Steam are installed but do not autostart on the guest machine.

### Recommended: live USB (no installation, no disk writes)

On an existing NixOS build machine, build the self-contained ISO:

```bash
cd ~/dotfiles
nix build .#demo-iso
ls -lh result/iso/*.iso
```

The ISO embeds the **full** app selection including large IDEs and games;
expect a large download/build and a correspondingly large image. Use a large
USB drive. Writing the ISO overwrites the **USB drive**, so verify its device:

```bash
lsblk -o NAME,SIZE,MODEL,TRAN,MOUNTPOINTS
sudo dd if=result/iso/cleboost-demo.iso of=/dev/sdX bs=4M status=progress conv=fsync
```

Replace `/dev/sdX` with the **whole USB device**, *never* the system disk or
a partition. Boot the target computer from USB (UEFI or legacy BIOS). It logs
into the `cleboost` Hyprland session automatically. Use `Ctrl+Alt+F2` to
access a rescue TTY if graphics cannot start; `nmtui` can connect to Wi-Fi.
There is no installed OS change or persistent user data: reboot and remove
the USB to return to the machine's existing system.

To try the image in a virtual machine, attach `result/iso/cleboost-demo.iso`
to a QEMU/KVM VM with **8 GiB+ RAM**, multiple vCPUs and VirtIO graphics.
3D/virgl acceleration makes Hyprland more likely to work properly than plain
QXL/Bochs; real hardware has a better chance of showing full animations.

### Optional: permanently apply the demo to an existing NixOS PC

Install NixOS first using its normal installer, creating the user `cleboost`,
then clone this repository and run:

```bash
git clone https://github.com/Cleboost/dotfiles.git ~/dotfiles
cd ~/dotfiles
bash scripts/install-demo.sh --apply
```

The script detects *that computer's* drives and kernel modules with
`nixos-generate-config`, saves them under
`hosts/cleboost-demo/hardware-configuration.nix`, stages that file for the
flake, builds the configuration, switches to it and prompts for a password.
It does **not** partition disks; it **does** replace the currently installed
system configuration. Do not use it on someone else's OS without their consent.

The generated hardware file is specific to that machine. **Do not commit or
push it.** Bootloader, encrypted storage and unusual partition layouts still
depend on the target's installer-generated hardware configuration.

### Compatibility

- Intended for **x86_64 Linux PCs** with UEFI or legacy BIOS and common
  Intel/AMD integrated graphics; open Nouveau provides limited NVIDIA support.
- Proprietary NVIDIA, Secure Boot restrictions, very new/exotic Wi-Fi adapters
  and some GPU setups may require per-machine driver or BIOS configuration.
- An ISO can be built once and tried on multiple PCs, including without an
  internet connection. A new persistent install needs connectivity to fetch
  the remaining Nix store closure unless it is already cached.
- Keep the base profiles (`cleboost-sage`, `cleboost-brain`) unchanged; all
  demo-specific adjustments live under `hosts/cleboost-demo/` or
  `modules/core/demo-live.nix`.

## License

Personal config — use at your own risk.
