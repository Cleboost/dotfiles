# ──────────────────────────────────────────────────────────────────────────────
# hosts/cleboost-brain/home.nix — Home Manager overrides (tower only)
# ──────────────────────────────────────────────────────────────────────────────
{ pkgs, ... }:

{
  home.packages = with pkgs; [
  ];

  # GPU stubs until PRIME is configured (Hypr & Umbriel read these paths)
  xdg.configFile."hypr/gpu-env.lua".text = "-- cleboost-brain: set GPU vars here (see hosts/cleboost-sage/gpu-env.nix)\n";

  xdg.configFile."umbriel/gpu-env.toml".text = ''
    # cleboost-brain — generated stub
    [environment]
  '';
}
