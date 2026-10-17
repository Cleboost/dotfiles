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
      Home Manager loads matching modules under home/groups/<name>/.
      NixOS modules (e.g. Steam, GameMode) use the same list.
    '';
  };

  options.cleboost.hypr = {
    dynamicWorkspaces = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        At Hyprland start, run manage_workspaces.sh to map workspaces to monitors.
        Disable on fixed multi-monitor desktops (cleboost-brain).
      '';
    };
  };

  options.cleboost.gaming.gpuDevice = lib.mkOption {
    type = lib.types.int;
    default = 0;
    description = ''
      DRM render node index for GameMode GPU tweaks (cleboost-sage uses 1 for PRIME dGPU).
    '';
  };
}
