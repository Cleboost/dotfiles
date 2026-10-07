# ──────────────────────────────────────────────────────────────────────────────
# home/packages/groups/dev.nix — IDEs, AI agents, compilers, runtimes
# ──────────────────────────────────────────────────────────────────────────────
{ config, lib, pkgs, inputs, ... }:

lib.mkIf (lib.elem "dev" config.cleboost.groups) {
  home.packages = with pkgs; [
    # ── IDEs ──────────────────────────────────────────────────────────────────
    zed-editor
    code-cursor
    jetbrains.idea
    jetbrains.rust-rover
    jetbrains.webstorm

    # ── IA ────────────────────────────────────────────────────────────────────
    antigravity-cli
    antigravity-ide
    inputs.chatgpt-desktop.packages.${stdenv.hostPlatform.system}.default
    codex
    inputs.grok-bot.packages.${stdenv.hostPlatform.system}.default

    # ── Runtimes & build ──────────────────────────────────────────────────────
    jdk21
    maven
    gradle
    bun
    nodejs_22
    rustup
    gcc
    gnumake

    # ── Other ─────────────────────────────────────────────────────────────────
    godot_4
  ];
}
