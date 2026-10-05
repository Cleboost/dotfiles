# Home Manager — cleboost-brain only
{ pkgs, ... }:

{
  home.packages = with pkgs; [
  ];

  # Stubs until GPU / PRIME is configured for this host (Hypr & Umbriel load these files).
  xdg.configFile."hypr/gpu-env.lua".text = "-- cleboost-brain: GPU vars go here (see hosts/cleboost-sage/gpu-env.nix)\n";

  xdg.configFile."umbriel/gpu-env.toml".text = ''
    # cleboost-brain — generated stub
    [environment]
  '';
}
