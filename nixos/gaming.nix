# ──────────────────────────────────────────────────────────────────────────────
# nixos/gaming.nix — GameMode, Ananicy, Steam, performance tools
# ──────────────────────────────────────────────────────────────────────────────
{ config, pkgs, ... }:

{
  # ── GameMode ────────────────────────────────────────────────────────────────
  programs.gamemode = {
    enable = true;
    enableRenice = true;
    settings = {
      general = {
        renice = 10;
      };
      gpu = {
        apply_gpu_optimisations = "accept-responsibility";
        gpu_device = 1;
        nv_powermizer_mode = 1; # Prefer maximum performance
      };
    };
  };

  # ── Ananicy (process priority rules) ────────────────────────────────────────
  services.ananicy = {
    enable = true;
    package = pkgs.ananicy-cpp;
    rulesProvider = pkgs.ananicy-rules-cachyos;
  };

  # ── Steam & Proton ──────────────────────────────────────────────────────────
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true;
    extraPackages = with pkgs; [
      gamemode
      mangohud
    ];
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
    package = pkgs.steam.override (prev: {
      extraLibraries = pkgs: [
        pkgs.gamemode.lib
        pkgs.pkgsi686Linux.gamemode.lib
        pkgs.mangohud
        pkgs.pkgsi686Linux.mangohud
      ] ++ (if prev ? extraLibraries then prev.extraLibraries pkgs else [ ]);
    });
  };

  # ── Extra gaming packages ───────────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    mangohud
    gamescope
  ];
}
