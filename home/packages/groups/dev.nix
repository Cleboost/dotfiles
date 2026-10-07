# ──────────────────────────────────────────────────────────────────────────────
# home/packages/groups/dev.nix — IDEs, AI agents, compilers, runtimes
# ──────────────────────────────────────────────────────────────────────────────
{ config, lib, pkgs, inputs, ... }:

lib.mkIf (lib.elem "dev" config.cleboost.groups) {
  home.packages = with pkgs; [
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
};
}
