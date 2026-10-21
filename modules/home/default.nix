# Home Manager entry. Host knobs are set in hosts/<name>/default.nix and copied here.
{ inputs, lib, osConfig ? null, hostName, username ? "cleboost", ... }:

let
  # Read a value from the NixOS config of this host. Fallback if HM is evaluated alone.
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
    ../core/options.nix
    ../../hosts/${hostName}/home.nix
    ./session.nix
    ./shell
    ./desktop
    ./apps
  ];
}
