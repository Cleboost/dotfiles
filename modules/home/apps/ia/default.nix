{ config, lib, pkgs, inputs, ... }:

lib.mkIf (lib.elem "ia" config.cleboost.groups) {
  home.packages = with pkgs; [
    antigravity-cli
    antigravity-ide
    code-cursor
    claude-code
    codex
    inputs.chatgpt-desktop.packages.${stdenv.hostPlatform.system}.default
    inputs.grok-bot.packages.${stdenv.hostPlatform.system}.default
  ];

  xdg.desktopEntries.cursor-acl = {
    name = "Cursor (ACL)";
    genericName = "Text Editor";
    comment = "Code Editing. Redefined. (ACL Environment)";
    exec = "${config.home.homeDirectory}/.local/bin/cursor-acl %F";
    icon = "cursor";
    terminal = false;
    type = "Application";
    categories = [ "Utility" "TextEditor" "Development" "IDE" ];
    mimeType = [ "text/plain" "inode/directory" ];
    actions = {
      "new-empty-window" = {
        name = "New Empty Window";
        exec = "${config.home.homeDirectory}/.local/bin/cursor-acl --new-window %F";
        icon = "cursor";
      };
    };
  };

  home.activation.antigravityCliSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    settings="${config.home.homeDirectory}/.gemini/antigravity-cli/settings.json"
    if [ ! -e "$settings" ]; then
      $DRY_RUN_CMD mkdir -p "$(dirname "$settings")"
      $DRY_RUN_CMD ${pkgs.jq}/bin/jq -n \
        --arg home "${config.home.homeDirectory}" \
        '{
          model: "Gemini 3.8 Flash (Low)",
          toolPermission: "always-proceed",
          trustedWorkspaces: [ $home, ($home + "/dotfiles") ]
        }' > "$settings"
      $DRY_RUN_CMD chmod 600 "$settings"
    fi
  '';
}
