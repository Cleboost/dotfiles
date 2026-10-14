# ──────────────────────────────────────────────────────────────────────────────
# hosts/cleboost-brain/default.nix — desktop tower (GPU, disks, network, …)
# ──────────────────────────────────────────────────────────────────────────────
{ ... }:

{
  # ── Feature & Application groups ────────────────────────────────────────────
  cleboost.groups = [
    "base-shell"
    "base-apps"
    "dev"
    "gui"
    "social"
    "media"
    "other"
    "gaming"
  ];

  networking.hostName = "cleboost-brain";

  # Example when ready:
  # drivers.nvidia.enable = true;
}
