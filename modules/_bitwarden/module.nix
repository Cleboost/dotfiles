{
  lib,
  osConfig,
  pkgs,
  ...
}:

lib.mkIf osConfig.cleboost.bitwarden {
  home.packages = [ pkgs.bitwarden-desktop ];
  home.activation.bitwardenSshAgent = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    BW_DATA="$HOME/.config/Bitwarden/data.json"
    if [ -f "$BW_DATA" ]; then
      TMP_FILE="$(mktemp)"
      ${pkgs.jq}/bin/jq '
        .global_desktopSettings_sshAgentEnabled = true
        | with_entries(
            if (.key | test("^user_.*_desktopSettings_sshAgentRememberAuthorizations$"))
            then .value = "rememberUntilLock"
            elif (.key | test("^user_.*_vaultTimeoutSettings_vaultTimeout$"))
            then .value = "never"
            else .
            end
          )
      ' "$BW_DATA" > "$TMP_FILE" && mv "$TMP_FILE" "$BW_DATA"
    fi
  '';
}
