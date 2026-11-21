# Tower — hardware and system only.
{ lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./storage.nix
    ./ugreen-wifi.nix
  ];

  cleboost = {
    antigravity = true;
    baseApps = true;
    beamng = true;
    bitwarden = true;
    chrome = true;
    claude = true;
    cpp = true;
    cursor = true;
    desktop = true;
    docker = true;
    dynamicWorkspaces = false;
    file-manager = {
      luciole = true;
      nautilus = true;
    };
    gaming = true;
    godot = true;
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

  networking.hostName = "cleboost-brain";

  # Intel I211 — primary Ethernet when cable is plugged in
  networking.firewall.trustedInterfaces = [ "enp5s0" ];

  # Titan X Pascal → legacy 580 branch (6xx driver rejects the card)
  drivers.nvidia = {
    enable = true;
    packageFlavour = "legacy_580";
    coolbits = 4; # ventilo manuel via nvidia-settings
  };

  boot.kernelParams = [
    "pcie_aspm.policy=performance"
  ];

  boot.kernelModules = lib.mkAfter [ "kvm-amd" ];
}
