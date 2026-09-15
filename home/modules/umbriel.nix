{ config, pkgs, ... }:

{
  # Link individual umbriel files so ~/.config/umbriel remains writable
  # (Noctalia generates noctalia.toml automatically in ~/.config/umbriel/noctalia.toml)
  xdg.configFile."umbriel/config.toml" = {
    source = ../files/umbriel/config.toml;
    force = true;
  };
  xdg.configFile."umbriel/custom.toml".source = ../files/umbriel/custom.toml;
  xdg.configFile."umbriel/appearance.toml".source = ../files/umbriel/appearance.toml;
  xdg.configFile."umbriel/shaders".source = ../files/umbriel/shaders;
  xdg.configFile."umbriel/scratchpads.toml".source = ../files/umbriel/scratchpads.toml;
  xdg.configFile."umbriel/core" = {
    source = ../files/umbriel/core;
    force = true;
  };
  xdg.configFile."umbriel/binds" = {
    source = ../files/umbriel/binds;
    force = true;
  };
  xdg.configFile."umbriel/rules" = {
    source = ../files/umbriel/rules;
    force = true;
  };
}
