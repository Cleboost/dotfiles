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
    type = lib.types.either lib.types.bool (lib.types.submodule {
      options = lib.mapAttrs (_: desc: mkToggleOn desc) fields;
    });
    default = defaultBool;
    apply = val:
      if builtins.isBool val then
        lib.mapAttrs (_: _: val) fields
      else
        val;
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
      session = "Desktop session scripts & environment";
      wireplumber = "WirePlumber audio rules";
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
    gui = mkToggle "GUI utilities (Obsidian, scrcpy, RustDesk)";
    ia = mkToggle "AI tools (Cursor, Claude Desktop, Grok, Rakazo)";
    media = mkToggle "Media apps (mpv, feh, pdfcraft, lollypop)";
    other = mkToggle "3D / Creative apps (Blender, Blockbench)";
    discord = mkToggle "Discord & Vesktop";
    spotify = mkToggle "Spotify";
    telegram = mkToggle "Telegram Desktop";
    zapfast = mkToggle "ZapFast";
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
