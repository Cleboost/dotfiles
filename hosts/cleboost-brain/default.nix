# cleboost-brain — futur PC fixe / second poste
# Ajoute ici modules ou options propres à brain (GPU, disques, réseau, …).
{ ... }:

{
  networking.hostName = "cleboost-brain";

  # Exemple pour activer plus tard :
  # imports = [ ../../nixos/nvidia.nix ];
}
