# Flat feature toggles for NixOS & Home Manager.
# Set them in hosts/<host>/default.nix as `cleboost.<name> = true/false;`.
{ lib, ... }:

let
  mkToggle = desc: lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = desc;
  };
  mkToggleOn = desc: lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = desc;
  };
  mkGroup = fields: defaultBool: lib.mkOption {
    type = lib.types.submodule {
      options = lib.mapAttrs (_: desc: mkToggle desc) fields;
    };
    default = { };
    description = "Feature group (default: all ${if defaultBool then "enabled" else "disabled"}).";
  };
in
{
  options.cleboost = {
    # ── Presets (groups) ─────────────────────────────────────────────────────
    server = mkToggle "Headless server preset (VPS)";
    desktop = mkToggle "Desktop workstation preset";
    dev = mkToggle "Development preset";
    gaming = mkToggle "Gaming preset";

    # ── System services ──────────────────────────────────────────────────────
    docker = mkToggle "Docker daemon and compose";
    openssh = mkToggle "OpenSSH server";
    keyring = mkToggle "GNOME Keyring";
    keychron = mkToggle "Keychron udev rules";
    platformio = mkToggle "PlatformIO udev rules";

    # ── Desktop & Shell ──────────────────────────────────────────────────────
    shell = mkGroup {
      hyprland = "Hyprland window manager";
      noctalia = "Noctalia shell & greeter";
      umbriel = "Umbriel";
    } false;
    file-manager = mkGroup {
      nautilus = "Nautilus file manager";
      luciole = "Luciole file manager";
    } false;
    theme = mkToggle "GTK/Qt/Cursor theme";

    # ── Terminal & CLI ───────────────────────────────────────────────────────
    terminal = mkGroup {
      zsh = "Zsh shell and CLI tools";
      kitty = "Kitty terminal";
      starship = "Starship prompt";
      fastfetch = "Fastfetch system info";
    } false;
    ssh = mkToggle "SSH client config";

    # ── Apps (1 app / group = 1 module) ──────────────────────────────────────
    baseApps = mkToggle "Base CLI & browser apps (Chrome, gh, ripgrep, etc.)";
    scrcpy = mkToggle "scrcpy + android-tools (adb/fastboot)";
    obsidian = mkToggle "Obsidian";
    rustdesk = mkToggle "RustDesk";
    cursor = mkToggle "Cursor IDE & CLI";
    claude = mkToggle "Claude Desktop";
    grok-bot = mkToggle "Grok Bot";
    rakazo = mkToggle "Rakazo";
    feh = mkToggle "feh image viewer";
    mpv = mkToggle "mpv media player";
    pdfcraft = mkToggle "PDFCraft";
    lollypop = mkToggle "Lollypop music player";
    other = mkToggle "3D / Creative apps (Blender, Blockbench)";
    social = mkGroup {
      discord = "Discord & Vesktop";
      telegram = "Telegram Desktop";
      zapfast = "ZapFast";
    } false;
    spotify = mkToggle "Spotify";
    zed = mkToggle "Zed editor";
    antigravity = mkToggle "Antigravity Hub";
    beamng = mkToggle "BeamNG.drive tools";
    qbittorrent = mkToggle "qBittorrent";
    bitwarden = mkToggle "Bitwarden";
    rquickshare = mkToggle "RQuickShare";

    # ── Extra host knobs ─────────────────────────────────────────────────────
    dynamicWorkspaces = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Run manage_workspaces.sh on Hyprland startup.";
    };

    gpuDevice = lib.mkOption {
      type = lib.types.int;
      default = 0;
      description = "DRM render node index for GameMode GPU tweaks.";
    };
  };
}
