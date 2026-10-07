# ──────────────────────────────────────────────────────────────────────────────
# home/packages/groups/code.nix — minimal editor (pulled in with dev group)
# ──────────────────────────────────────────────────────────────────────────────
{ config, lib, pkgs, ... }:

let
  enabled =
    lib.elem "code" config.cleboost.groups
    || lib.elem "dev" config.cleboost.groups;
in
lib.mkIf enabled {
  home.packages = with pkgs; [
    zed-editor
  ];
}
