# Laptop — paquets HM, PRIME GPU env, BeamNG.
{ pkgs, ... }:

{
  imports = [
    ./gpu.nix
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
