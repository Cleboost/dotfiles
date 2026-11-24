{ lib, ... }:
let
  hosts = [ "tour" "laptop" ];
  mod = { pkgs, ... }: {
    programs.gamemode = {
      enable = true;
      enableRenice = true;
      settings = {
        general.renice = 10;
        custom = {
          start = "${pkgs.power-profiles-daemon}/bin/powerprofilesctl set performance";
          end = "${pkgs.power-profiles-daemon}/bin/powerprofilesctl set power-saver";
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
      extraPackages = with pkgs; [ gamemode mangohud ];
      extraCompatPackages = with pkgs; [ proton-ge-bin ];
      package = pkgs.steam.override (prev: {
        extraLibraries = pkgs: [
          pkgs.gamemode.lib
          pkgs.pkgsi686Linux.gamemode.lib
          pkgs.mangohud
          pkgs.pkgsi686Linux.mangohud
        ] ++ (if prev ? extraLibraries then prev.extraLibraries pkgs else [ ]);
      });
    };
  };
in {
  flake.modules.nixos = lib.genAttrs hosts (_: mod);
}
