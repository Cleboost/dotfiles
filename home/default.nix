# Home Manager entry point — all personal config lives under home/.
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
    stateVersion = "25.05";
  };

  cleboost = {
    groups = fromHost [ "cleboost" "groups" ] [ "base-shell" "base-apps" ];
    hypr.dynamicWorkspaces = fromHost [ "cleboost" "hypr" "dynamicWorkspaces" ] true;
  };

  imports = [
    inputs.noctalia.homeModules.default
    inputs.umbriel.homeModules.default
    "${inputs.hm-pr-zapfast}/modules/programs/zapfast.nix"
    ./config/umbriel/module.nix
    ../system/options.nix
    ./module.nix
  ];
}
