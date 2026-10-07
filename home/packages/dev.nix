# ──────────────────────────────────────────────────────────────────────────────
# home/packages/dev.nix — IDEs, AI tools, compilers, runtimes
# ──────────────────────────────────────────────────────────────────────────────
{ pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    # Editors & AI agents
    zed-editor
    code-cursor
    jetbrains.idea
    jetbrains.rust-rover
    antigravity-cli
    antigravity-ide
    inputs.chatgpt-desktop.packages.${stdenv.hostPlatform.system}.default
    codex
    inputs.grok-bot.packages.${stdenv.hostPlatform.system}.default

    # Compilers, runtimes & engines
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
}
