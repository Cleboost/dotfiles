{
  config,
  lib,
  pkgs,
  hostName,
  ...
}:

lib.mkIf (lib.elem "ia" config.cleboost.groups) {
  home.packages = with pkgs; [
    (callPackage ../../pkgs/antigravity-cli.nix { inherit antigravity-cli; })
    antigravity-hub
  ];

  home.activation.antigravityCliSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    settings="${config.home.homeDirectory}/.gemini/antigravity-cli/settings.json"
    if [ ! -e "$settings" ]; then
      $DRY_RUN_CMD mkdir -p "$(dirname "$settings")"
      $DRY_RUN_CMD ${pkgs.jq}/bin/jq -n \
        --arg home "${config.home.homeDirectory}" \
        '{
          model: "Gemini 4 Hydrogen (Low)",
          toolPermission: "always-proceed",
          trustedWorkspaces: [ $home, ($home + "/dotfiles") ]
        }' > "$settings"
      $DRY_RUN_CMD chmod 600 "$settings"
    fi
  '';

  home.activation.antigravityHubConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    cfg="${config.home.homeDirectory}/.gemini/config/config.json"
    $DRY_RUN_CMD mkdir -p "$(dirname "$cfg")"
    $DRY_RUN_CMD ${pkgs.jq}/bin/jq -n \
      --arg host "${hostName}" \
      '{
        userSettings: {
          autoExecutionPolicy: "CASCADE_COMMANDS_AUTO_EXECUTION_EAGER",
          enableTerminalSandbox: false,
          nonWorkspaceFileAccessPolicy: "AGENT_SETTING_POLICY_ALLOW",
          permissionGrantsV2Migrated: true,
          permissionPreset: "AGENT_PERMISSION_PRESET_TURBO",
          remoteControlEnabled: true,
          remoteControlHostname: $host,
          sandboxEnabledAtV2Migration: true
        }
      }' > "$cfg"
    $DRY_RUN_CMD chmod 600 "$cfg"
  '';
}
