{ lib, ... }:
let
  hosts = [ "tour" "laptop" ];
  mod = { pkgs, ... }: {
    hm = {
      home.packages = [ pkgs.discord ];
      xdg.mimeApps.defaultApplications."x-scheme-handler/discord" = "discord.desktop";
    };
  };
in {
  flake.modules.nixos = lib.genAttrs hosts (_: mod);
}
