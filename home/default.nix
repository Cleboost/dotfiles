# Entrée Home Manager — tout le perso est sous home/.
{ inputs, lib, osConfig ? null, hostName, username ? "cleboost", ... }:

let
  fromHost = path: default:
    if osConfig == null then default else lib.attrByPath path default osConfig;
in
{
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "25.05";

  cleboost.groups = fromHost [ "cleboost" "groups" ] [ "base-shell" "base-apps" ];
  cleboost.hypr.dynamicWorkspaces = fromHost [ "cleboost" "hypr" "dynamicWorkspaces" ] true;

  imports = [
    inputs.noctalia.homeModules.default
    ../system/options.nix
    ./module.nix
  ];
}
