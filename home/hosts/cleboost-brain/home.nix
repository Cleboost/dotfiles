# Tour — paquets HM, GPU env, BeamNG.
{ pkgs, ... }:

{
  imports = [
    ./gpu.nix
  ];

  cleboost.beamng.cheatMenu = {
    enable = true;
    installPaths = [
      "/home/cleboost/.local/share/Steam/steamapps/common/BeamNG.drive"
      "/mnt/games/SteamLibrary/steamapps/common/BeamNG.drive"
    ];
  };

  home.packages = with pkgs; [
    nvtopPackages.nvidia
    lm_sensors
    (callPackage ../../pkgs/codex-chatgpt-web.nix { })
  ];
}
