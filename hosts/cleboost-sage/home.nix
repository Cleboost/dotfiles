# Paquets et diffs Home Manager du laptop. Noctalia = hosts/cleboost-sage/noctalia.nix.
{ pkgs, ... }:

{
  imports = [
    ./gpu-env.nix
  ];

  cleboost.beamng.cheatMenu = {
    enable = true;
    installPaths = [
      "/mnt/games/SteamLibrary/steamapps/common/BeamNG.drive"
    ];
  };

  home.packages = with pkgs; [
    (callPackage ../../pkgs/codex-chatgpt-web.nix { })
  ];
}
