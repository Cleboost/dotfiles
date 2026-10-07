# ──────────────────────────────────────────────────────────────────────────────
# hosts/cleboost-brain/home.nix — Home Manager overrides (tower only)
# ──────────────────────────────────────────────────────────────────────────────
{ pkgs, ... }:

{
  home.packages = with pkgs; [
  ];

  # GPU stub until PRIME is configured (Hyprland reads this path)
  xdg.configFile."hypr/gpu-env.lua".text = "-- cleboost-brain: set GPU vars here (see hosts/cleboost-sage/gpu-env.nix)\n";
}
