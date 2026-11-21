# Laptop — hardware and system only.
{ username, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  home-manager.users.${username}.imports = [ ./gpu.nix ];

  cleboost = {
    desktop = true;
    docker = true;
    openssh = true;
    keyring = true;
    keychron = true;
    platformio = true;
    gaming = true;
    gpuDevice = 1;

    shell = {
      hyprland = true;
      noctalia = true;
      umbriel = true;
    };
    file-manager = {
      nautilus = true;
      luciole = true;
    };
    theme = true;

    terminal = {
      zsh = true;
      kitty = true;
      starship = true;
      fastfetch = true;
    };
    ssh = true;

    baseApps = true;
    dev = true;
    scrcpy = true;
    rustdesk = true;
    cursor = true;
    claude = true;
    grok-bot = true;
    rakazo = true;
    media = {
      qbittorrent = true;
      mpv = true;
      feh = true;
      pdfcraft = true;
      obsidian = true;
      lollypop = true;
    };
    other = true;
    social = {
      discord = true;
      telegram = true;
      zapfast = true;
    };
    spotify = true;
    zed = true;
    antigravity = true;
    beamng = true;
    bitwarden = true;
    rquickshare = true;
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
