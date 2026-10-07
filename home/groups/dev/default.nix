{ config, lib, pkgs, inputs, ... }:

lib.mkIf (lib.elem "dev" config.cleboost.groups) {
  home.packages = with pkgs; [
    zed-editor
    code-cursor
    jetbrains.idea
    jetbrains.rust-rover
    jetbrains.webstorm
    antigravity-cli
    antigravity-ide
    inputs.chatgpt-desktop.packages.${stdenv.hostPlatform.system}.default
    codex
    inputs.grok-bot.packages.${stdenv.hostPlatform.system}.default
    jdk21
    maven
    gradle
    bun
    nodejs_22
    rustup
    gcc
    gnumake
    godot_4
  ];

  xdg.configFile."zed/settings.json".source = ./zed/settings.json;

  xdg.mimeApps.defaultApplications = {
    "x-scheme-handler/jetbrains" = "jetbrainsd.desktop";
    "text/plain" = "dev.zed.Zed.desktop";
    "application/toml" = "dev.zed.Zed.desktop";
  };

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
}
