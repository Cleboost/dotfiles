# Home Manager entry point for VPS (nixpkgs stable).
{
  inputs,
  lib,
  osConfig ? null,
  hostName,
  username ? "cleboost",
  ...
}:

let
  fromHost =
    path: default: if osConfig == null then default else lib.attrByPath path default osConfig;
in
{
  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    stateVersion = "26.05";
  };

  cleboost = {
    server = true;
    groups = fromHost [ "cleboost" "groups" ] [ "server-shell" ];
  };

  imports = [
    "${inputs.hm-pr-zapfast}/modules/programs/zapfast.nix"
    ../system/options.nix
    ./module-server.nix
  ];
}
