# Development runtimes, SDKs, compilers & dev utilities
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # JVM ecosystem
    jdk21
    maven
    gradle

    # JS / TS ecosystem
    bun
    nodejs_22

    # Rust & C/C++ toolchains
    rustup
    gcc
    gnumake

    # Game Development
    godot_4
  ];
}
