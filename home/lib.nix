# Shared helpers for home/* modules.
{ lib, hostName }:

let
  hostFile = hostsDir: hostsDir + "/${hostName}.nix";
in
{
  # Attrset overlay: hosts/<hostname>.nix receives { lib, base }.
  overlay =
    base: hostsDir:
    let
      file = hostFile hostsDir;
    in
    if builtins.pathExists file then import file { inherit lib base; } else base;

  # Home Manager fragment: hosts/<hostname>.nix is a full HM module.
  module =
    hostsDir: env:
    let
      file = hostFile hostsDir;
    in
    if builtins.pathExists file then import file env else { };
}
