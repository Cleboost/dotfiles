# ──────────────────────────────────────────────────────────────────────────────
# hosts/cleboost-sage/home.nix — Home Manager overrides (laptop only)
# ──────────────────────────────────────────────────────────────────────────────
{ pkgs, ... }:

{
  imports = [
    ./gpu-env.nix
  ];

  # Host-only packages (shared lists live in home/packages/)
  home.packages = with pkgs; [
  ];
}
