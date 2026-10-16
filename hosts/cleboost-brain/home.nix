# ──────────────────────────────────────────────────────────────────────────────
# hosts/cleboost-brain/home.nix — Home Manager overrides (tower only)
# ──────────────────────────────────────────────────────────────────────────────
{ pkgs, ... }:

{
  cleboost.beamng.cheatMenu = {
    enable = true;
    installPaths = [
      "/home/cleboost/.local/share/Steam/steamapps/common/BeamNG.drive"
    ];
  };

  home.packages = with pkgs; [
  ];

  # GPU stub until PRIME is configured (Hyprland reads this path)
  xdg.configFile."hypr/gpu-env.lua".text = "-- cleboost-brain: set GPU vars here (see hosts/cleboost-sage/gpu-env.nix)\n";
}
