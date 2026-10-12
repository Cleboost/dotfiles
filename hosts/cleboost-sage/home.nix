# ──────────────────────────────────────────────────────────────────────────────
# hosts/cleboost-sage/home.nix — Home Manager overrides (laptop only)
# ──────────────────────────────────────────────────────────────────────────────
{ pkgs, ... }:

{
  imports = [
    ./gpu-env.nix
  ];

  # Host-only packages (shared groups live in home/groups/)
  home.packages = with pkgs; [
    (callPackage ../../pkgs/codex-chatgpt-web.nix { })
  ];
}

