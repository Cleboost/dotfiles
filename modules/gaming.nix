# Gaming optimizations module
{ config, pkgs, ... }:

{
  # GameMode (Feral Interactive) - dynamic CPU, GPU and process priority tuning for games
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
        nv_powermizer_mode = 1; # Prefer Maximum Performance
      };
    };
  };

  # Steam & Proton gaming support
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
      proton-ge-bin # Custom GloriousEggroll Proton build for wide game compatibility
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

  # Gaming performance utilities
  environment.systemPackages = with pkgs; [
    mangohud # On-screen FPS, GPU/CPU monitoring HUD
    gamescope # Micro-compositor for resolution scaling and HDR/FSR
  ];
}
