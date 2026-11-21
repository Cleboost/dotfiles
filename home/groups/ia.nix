{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

lib.mkIf (lib.elem "ia" config.cleboost.groups) {
  home.packages = with pkgs; [
    code-cursor
    cursor-cli
    claude-desktop
    #codex
    #inputs.chatgpt-desktop.packages.${stdenv.hostPlatform.system}.default
    inputs.grok-bot.packages.${stdenv.hostPlatform.system}.default
    # Electron client: local UI; on 1st launch "This computer" the app manages the stack (Docker already on host).
    (callPackage ../pkgs/rakazo.nix { })
  ];

  # Cursor (ACL) — disabled: ACL no longer ships Cursor; restore block below when needed.
  # xdg.desktopEntries.cursor-acl = {
  #   name = "Cursor (ACL)";
  #   genericName = "Text Editor";
  #   comment = "Code Editing. Redefined. (ACL Environment)";
  #   exec = "${config.home.homeDirectory}/.local/bin/cursor-acl %F";
  #   icon = "cursor";
  #   terminal = false;
  #   type = "Application";
  #   categories = [ "Utility" "TextEditor" "Development" "IDE" ];
  #   mimeType = [ "text/plain" "inode/directory" ];
  #   actions = {
  #     "new-empty-window" = {
  #       name = "New Empty Window";
  #       exec = "${config.home.homeDirectory}/.local/bin/cursor-acl --new-window %F";
  #       icon = "cursor";
  #     };
  #   };
  # };
}
