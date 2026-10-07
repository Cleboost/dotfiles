# ──────────────────────────────────────────────────────────────────────────────
# modules/cleboost/default.nix — shared options (NixOS + Home Manager)
# ──────────────────────────────────────────────────────────────────────────────
{ lib, ... }:

{
  options.cleboost.groups = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [ "base-shell" "base-apps" ];
    example = [ "base-shell" "base-apps" "dev" "gui" "gaming" ];
    description = ''
      Package and feature groups for this host.
      Home Manager loads matching lists under home/packages/groups/.
      NixOS modules (e.g. Steam, GameMode) use the same list.
    '';
  };
}
