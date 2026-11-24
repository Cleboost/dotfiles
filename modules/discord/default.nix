{ lib, ... }:
let
  hosts = [ "tour" "laptop" ];
  mod = { pkgs, ... }: {
    hm = {
      home.packages = with pkgs; [
        discord
        vesktop
      ];

      xdg.mimeApps.defaultApplications."x-scheme-handler/discord" = "discord.desktop";
    };
  };
in {
  flake.modules.nixos = lib.genAttrs hosts (_: mod);
}
