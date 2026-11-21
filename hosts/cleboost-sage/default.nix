# Laptop — hardware and system only.
{ username, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  home-manager.users.${username}.imports = [ ./gpu.nix ];

  cleboost = {
    antigravity = true;
    bitwarden = true;
    chrome = true;
    claude = true;
    cpp = true;
    cursor = true;
    desktop = true;
    docker = true;
    file-manager = {
      luciole = true;
      nautilus = true;
    };
    gaming = {
      beammp = true;
      beamng = true;
      gamescope = true;
      mangohud = true;
      prismlauncher = true;
      protontricks = true;
      steam = true;
    };
    godot = true;
    gpuDevice = 1;
    grok-bot = true;
    idea = true;
    javascript = true;
    keychron = true;
    keyring = true;
    kicad = true;
    media = {
      feh = true;
      lollypop = true;
      mpv = true;
      obsidian = true;
      pdfcraft = true;
      qbittorrent = true;
    };
    nix-dev = true;
    openssh = true;
    other = true;
    platformio = true;
    rakazo = true;
    rquickshare = true;
    rust = true;
    rustdesk = true;
    scrcpy = true;
    shell = {
      hyprland = true;
      noctalia = true;
      umbriel = true;
    };
    social = {
      discord = true;
      telegram = true;
      zapfast = true;
    };
    spotify = true;
    ssh = true;
    terminal = {
      fastfetch = true;
      kitty = true;
      starship = true;
      zsh = true;
    };
    zed = true;
  };

  drivers.nvidia = {
    enable = true;
    prime.enable = true;
  };
  drivers.asus-fan-control.enable = true;

  networking.hostName = "cleboost-sage";
  networking.firewall.trustedInterfaces = [ "wlp3s0" ];

  # Aquamarine splits AQ_DRM_DEVICES on ':'. The by-path node contains colons,
  # so Hyprland gets a colon-free symlink to the AMD iGPU only.
  systemd.tmpfiles.rules = [
    "L+ /run/dri/amd-card - - - - /dev/dri/by-path/pci-0000:06:00.0-card"
  ];

  hardware.flipperzero.enable = true;
}
