{ config, lib, osConfig ? null, hostName, username ? "cleboost", ... }:

{
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "25.05";

  # Synchronize group selections from the host's NixOS config
  cleboost.groups = if (osConfig != null && osConfig ? cleboost.groups) then osConfig.cleboost.groups else [ "base-shell" "base-apps" ];

  cleboost.hypr.dynamicWorkspaces =
    if osConfig == null then
      true
    else
      lib.attrByPath [ "cleboost" "hypr" "dynamicWorkspaces" ] true osConfig;

  imports = [
    ../core/options.nix
    ../../hosts/${hostName}/home.nix
    ./session.nix
    ./shell
    ./desktop
    ./apps
  ];
}
