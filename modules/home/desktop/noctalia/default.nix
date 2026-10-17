# Shared Noctalia config + per-host overrides (cleboost.noctalia).
{ config, lib, pkgs, ... }:

let
  cfg = config.cleboost.noctalia;
  base = builtins.readFile ./config.toml;
  rendered = import ./render.nix { inherit lib cfg base; };
in
{
  xdg.configFile."noctalia/config.toml".source =
    pkgs.writeText "noctalia-config.toml" rendered;
}
