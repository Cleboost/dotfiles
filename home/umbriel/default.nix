# ──────────────────────────────────────────────────────────────────────────────
# home/umbriel/default.nix — Umbriel compositor config (per-file links for Noctalia)
# ──────────────────────────────────────────────────────────────────────────────
{ config, pkgs, ... }:

{
  xdg.configFile."umbriel/config.toml" = {
    source = ./config.toml;
    force = true;
  };
  xdg.configFile."umbriel/custom.toml".source = ./custom.toml;
  xdg.configFile."umbriel/appearance.toml".source = ./appearance.toml;
  xdg.configFile."umbriel/shaders".source = ./shaders;
  xdg.configFile."umbriel/scratchpads.toml".source = ./scratchpads.toml;
  xdg.configFile."umbriel/core" = {
    source = ./core;
    force = true;
  };
  xdg.configFile."umbriel/binds" = {
    source = ./binds;
    force = true;
  };
  xdg.configFile."umbriel/rules" = {
    source = ./rules;
    force = true;
  };
}
