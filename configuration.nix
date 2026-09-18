# Main NixOS system configuration for Cleboost
{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/nvidia.nix
    ./modules/desktop.nix
    ./modules/noctalia.nix
    ./modules/packages.nix
    ./modules/gaming.nix
  ];

  # Nix package manager settings and Flakes configuration
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [
      "https://cache.nixos.org"
      "https://noctalia.cachix.org"
      "https://hyprland.cachix.org"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    auto-optimise-store = true;
  };

  # Periodic background optimisation of Nix store
  nix.optimise.automatic = true;

  # NH (Nix Helper) - Clean, fast, and visual CLI for NixOS/Flakes
  programs.nh = {
    enable = true;
    flake = "/home/cleboost/dotfiles";
    clean = {
      enable = true;
      extraArgs = "--keep 10";
      dates = "weekly";
    };
  };

  # SSD TRIM maintenance
  services.fstrim = {
    enable = true;
    interval = "weekly";
  };

  # Automatic cleanup: retain only the last 10 generations of the system and home-manager
  systemd.services.nix-clean-generations = {
    description = "Retain only the last 10 NixOS generations and garbage collect unreferenced store paths";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.writeShellScript "nix-keep-10-generations" ''
        ${pkgs.nix}/bin/nix-env --profile /nix/var/nix/profiles/system --delete-generations +10
        ${pkgs.su}/bin/su - cleboost -c '${pkgs.nix}/bin/nix-env --delete-generations +10' || true
        ${pkgs.nix}/bin/nix-collect-garbage
      ''}";
    };
  };

  systemd.timers.nix-clean-generations = {
    description = "Weekly timer to clean NixOS generations beyond the latest 10";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "weekly";
      Persistent = true;
    };
  };

  # Shell aliases for system rebuild and updates
  environment.shellAliases = {
    rebuild = "sudo nixos-rebuild switch --flake /home/cleboost/dotfiles#cleboost-brain";
    update  = "nix flake update --flake /home/cleboost/dotfiles && sudo nixos-rebuild switch --flake /home/cleboost/dotfiles#cleboost-brain";
  };

  # Boot optimizations & /tmp cleanup
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.tmp.cleanOnBoot = true;

  # ZRAM swap (compressed in-RAM swap, prevents out-of-memory stalls without wearing SSD)
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };

  # Kernel memory & gaming responsiveness tuning
  boot.kernel.sysctl = {
    "vm.swappiness" = 180;             # Optimal with zram to favor compressed RAM over disk cache eviction
    "vm.watermark_boost_factor" = 0;   # Reduces stuttering and latency spikes under memory pressure
    "vm.watermark_scale_factor" = 125; # Proactively reclaim memory to prevent sudden drops
    "vm.max_map_count" = 2147483642;   # Required for modern high-performance games and Proton
  };

  # Bound systemd journal logs to prevent disk bloat
  services.journald.settings.Journal = {
    SystemMaxUse = "500M";
    MaxRetentionSec = "1month";
  };

  # Bound systemd coredump storage (prevents large crash dumps from gaming/apps)
  systemd.coredump.settings.Coredump = {
    Storage = "external";
    MaxUse = "1G";
  };

  # V4L2 Loopback virtual camera (for scrcpy / phone webcam)
  boot.extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
  boot.kernelModules = [ "v4l2loopback" ];
  boot.extraModprobeConfig = ''
    options v4l2loopback video_nr=20 card_label="Phone Camera" exclusive_caps=1
  '';

  # Networking & DNS
  networking = {
    hostName = "cleboost-brain";
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
    };
    nameservers = [
      "1.1.1.1#cloudflare-dns.com"
      "1.0.0.1#cloudflare-dns.com"
      "2606:4700:4700::1111#cloudflare-dns.com"
      "2606:4700:4700::1001#cloudflare-dns.com"
    ];
    firewall = {
      enable = true;
    };
  };

  # Fast & secure local DNS resolver with DNS-over-TLS (Cloudflare)
  services.resolved = {
    enable = true;
    settings.Resolve = {
      DNS = "1.1.1.1#cloudflare-dns.com 1.0.0.1#cloudflare-dns.com 2606:4700:4700::1111#cloudflare-dns.com 2606:4700:4700::1001#cloudflare-dns.com";
      FallbackDNS = "1.1.1.1 8.8.8.8";
      DNSOverTLS = "opportunistic";
      DNSSEC = "allow-downgrade";
    };
  };

  # Localization & Timezone
  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "fr_FR.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  # Primary user account
  users.users.cleboost = {
    isNormalUser = true;
    description = "Cleboost";
    shell = pkgs.fish;
    extraGroups = [ "networkmanager" "wheel" "video" "input" "adbusers" ];
  };

  # Enable running unpatched dynamic binaries (useful for IDE runtimes/tools)
  programs.nix-ld.enable = true;

  # NixOS state version
  system.stateVersion = "25.05";
}
