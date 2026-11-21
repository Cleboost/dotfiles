# Tower — hardware and system only.
{ lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./storage.nix
    ./ugreen-wifi.nix
  ];

  cleboost = {
    desktop = true;
    docker = true;
    openssh = true;
    keyring = true;
    keychron = true;
    platformio = true;
    gaming = true;
    dynamicWorkspaces = false;

    shell = {
      hyprland = true;
      noctalia = true;
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
