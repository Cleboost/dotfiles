# Flat feature toggles for NixOS & Home Manager.
# Set them in hosts/<host>/default.nix as `cleboost.<name> = true/false;`.
{ lib, ... }:

let
  mkToggle =
    desc:
    lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = desc;
    };
  mkToggleOn =
    desc:
    lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = desc;
    };
  mkGroup =
    fields: defaultBool:
    lib.mkOption {
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
    cpp = mkToggle "C/C++ toolchain (gcc, gnumake, ninja, just)";
    gaming = mkGroup {
      beammp = "BeamMP Launcher";
      beamng = "BeamNG.drive tools";
      gamescope = "Gamescope";
      mangohud = "MangoHud";
      prismlauncher = "Prism Launcher";
      protontricks = "Protontricks";
      steam = "Steam, GameMode & Ananicy";
    } false;
    godot = mkToggle "Godot 4";
    idea = mkToggle "JetBrains IDEA & WebStorm + JDK/Maven/Gradle";
    javascript = mkToggle "JavaScript/TypeScript (bun, nodejs_22)";
    kicad = mkToggle "KiCad";
    nix-dev = mkToggle "Nix dev tools (nvd, nixpkgs-review, nom)";
    rust = mkToggle "Rust (rustup, just)";

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

    # ── Terminal & CLI ───────────────────────────────────────────────────────
    terminal = mkGroup {
      zsh = "Zsh shell and CLI tools";
      kitty = "Kitty terminal";
      starship = "Starship prompt";
      fastfetch = "Fastfetch system info";
    } false;
    ssh = mkToggle "SSH client config";

    # ── Apps (1 app / group = 1 module) ──────────────────────────────────────
    chrome = mkToggle "Google Chrome";
    scrcpy = mkToggle "scrcpy + android-tools (adb/fastboot)";
    cursor = mkToggle "Cursor IDE & CLI";
    claude = mkToggle "Claude Desktop";
    ollama = mkToggle "Ollama local LLM server";
    grok-bot = mkToggle "Grok Bot";
    rakazo = mkToggle "Rakazo";
    rustdesk = mkToggle "RustDesk";
    media = mkGroup {
      qbittorrent = "qBittorrent";
      mpv = "mpv media player";
      feh = "feh image viewer";
      pdfcraft = "PDFCraft";
      obsidian = "Obsidian";
      lollypop = "Lollypop music player";
    } false;
    other = mkToggle "3D / Creative apps (Blender, Blockbench)";
    social = mkGroup {
      discord = "Discord & Vesktop";
      telegram = "Telegram Desktop";
      zapfast = "ZapFast";
    } false;
    spotify = mkToggle "Spotify";
    zed = mkToggle "Zed editor";
    antigravity = mkToggle "Antigravity Hub";
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
