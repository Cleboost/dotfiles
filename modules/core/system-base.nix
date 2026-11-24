{ ... }: {
  flake.modules.nixos.core = { lib, pkgs, username, ... }: {
    hm.home.stateVersion = "24.11";

    users.users.${username} = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
    };

    boot.loader.systemd-boot.enable = lib.mkDefault true;
    boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;
    boot.kernelPackages = pkgs.linuxPackages_xanmod_latest;
    boot.tmp.cleanOnBoot = true;
    boot.kernel.sysctl = {
      "vm.swappiness" = 180;
      "net.core.default_qdisc" = "fq";
      "net.ipv4.tcp_congestion_control" = "bbr";
      "net.ipv4.tcp_fastopen" = 3;
      "vm.watermark_boost_factor" = 0;
      "vm.watermark_scale_factor" = 125;
      "vm.max_map_count" = 2147483642;
    };

    time.timeZone = "Europe/Paris";
    i18n.defaultLocale = "fr_FR.UTF-8";
    console.keyMap = "fr";

    networking.networkmanager.enable = true;
    services.netbird.enable = true;

    environment.systemPackages = with pkgs; [
      curl
      wget
      git
      gh
      htop
      nano
    ];

    fonts = {
      packages = with pkgs; [
        nerd-fonts.jetbrains-mono
        font-awesome
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-color-emoji
        roboto
        liberation_ttf
        corefonts
      ];
      fontconfig = {
        enable = true;
        defaultFonts = {
          sansSerif = [ "Roboto" "Noto Sans" "DejaVu Sans" ];
          serif = [ "Liberation Serif" "DejaVu Serif" ];
          monospace = [ "JetBrainsMono Nerd Font" "DejaVu Sans Mono" ];
          emoji = [ "Noto Color Emoji" ];
        };
      };
    };
  };
}
