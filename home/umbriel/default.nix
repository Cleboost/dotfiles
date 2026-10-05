{ config, pkgs, ... }:

{
  # Link individual umbriel files so ~/.config/umbriel remains writable
  # (Noctalia generates noctalia.toml automatically in ~/.config/umbriel/noctalia.toml)
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
