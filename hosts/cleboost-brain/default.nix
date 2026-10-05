# ──────────────────────────────────────────────────────────────────────────────
# hosts/cleboost-brain/default.nix — desktop tower (GPU, disks, network, …)
# ──────────────────────────────────────────────────────────────────────────────
{ ... }:

{
  networking.hostName = "cleboost-brain";

  # Example when ready:
  # imports = [ ../../nixos/nvidia.nix ];
}
