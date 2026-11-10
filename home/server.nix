# Entrée Home Manager pour VPS (nixpkgs stable).
{ lib, osConfig ? null, hostName, username ? "cleboost", ... }:

let
  fromHost = path: default:
    if osConfig == null then default else lib.attrByPath path default osConfig;
in
{
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "26.05";

  cleboost.server = true;
  cleboost.groups = fromHost [ "cleboost" "groups" ] [ "server-shell" ];

  imports = [
    ../system/options.nix
    ./module-server.nix
  ];
}
