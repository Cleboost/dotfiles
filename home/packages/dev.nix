# IDEs, AI tools, compilers, runtimes.
{ pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    # Éditeurs & Agents IA
    zed-editor
    code-cursor
    jetbrains.idea
    jetbrains.rust-rover
    antigravity-cli
    antigravity-ide
    inputs.chatgpt-desktop.packages.${stdenv.hostPlatform.system}.default
    inputs.codex-cli.packages.${stdenv.hostPlatform.system}.default
    inputs.grok-bot.packages.${stdenv.hostPlatform.system}.default

    # Compilateurs, Runtimes & Moteurs
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
