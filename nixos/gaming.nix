# ──────────────────────────────────────────────────────────────────────────────
# nixos/gaming.nix — Steam, GameMode, Ananicy (cleboost.groups + "gaming")
# ──────────────────────────────────────────────────────────────────────────────
{ config, lib, pkgs, ... }:

lib.mkIf (lib.elem "gaming" config.cleboost.groups) {
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
        nv_powermizer_mode = 1;
      };
    };
  };

  services.ananicy = {
    enable = true;
    package = pkgs.ananicy-cpp;
    rulesProvider = pkgs.ananicy-rules-cachyos;
  };

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
}
