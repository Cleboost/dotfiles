# Home Manager — cleboost-brain only
{ ... }:

{
  # Stubs until GPU / PRIME is configured for this host (Hypr & Umbriel load these files).
  xdg.configFile."hypr/gpu-env.lua".text = "-- cleboost-brain: add PRIME vars in home/modules/gpu-env.nix or here\n";

  xdg.configFile."umbriel/gpu-env.toml".text = ''
    # cleboost-brain — generated stub
    [environment]
  '';
}
