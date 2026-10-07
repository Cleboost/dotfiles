# ──────────────────────────────────────────────────────────────────────────────
# hosts/cleboost-brain/default.nix — desktop tower (GPU, disks, network, …)
# ──────────────────────────────────────────────────────────────────────────────
{ ... }:

{
  imports = [
    ./profile.nix
  ];

  networking.hostName = "cleboost-brain";

  # Example when ready:
  # imports = [ ../../nixos/nvidia.nix ];
}
