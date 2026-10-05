# User packages: set `hosts` per app — "all", or [ "cleboost-sage" ], or [ "cleboost-brain" ].
{ pkgs, inputs, hostName, ... }:

let
  inherit (import ../../lib/home-packages.nix) pickForHost;

  all = "all";
  sage = [ "cleboost-sage" ];
  brain = [ "cleboost-brain" ];

  declarations = with pkgs; [
    # ── Applications Graphiques (GUI) ───────────────────────────
    # Navigateur & Communication
    { hosts = all; package = google-chrome; }
    { hosts = all; package = discord; }
    { hosts = all; package = telegram-desktop; }

    # Multimédia, Documents & Partage
    { hosts = all; package = nautilus; }
    { hosts = all; package = lollypop; }
    { hosts = all; package = mpv; }
    { hosts = all; package = feh; }
    { hosts = all; package = evince; }
    { hosts = all; package = spotifast; }
    { hosts = all; package = qbittorrent; }
    { hosts = all; package = rquickshare; }

    # Productivité, Notes & Bureau à distance
    { hosts = all; package = bitwarden-desktop; }
    { hosts = all; package = obsidian; }
    { hosts = all; package = scrcpy; }
    { hosts = all; package = android-tools; }
    {
      hosts = all;
      package = inputs.nixpkgs-rustdesk-pr.legacyPackages.${stdenv.hostPlatform.system}.rustdesk-flutter-nightly;
    }

    # Gaming & 3D
    { hosts = all; package = prismlauncher; }
    { hosts = all; package = blockbench; }
    { hosts = all; package = beammp-launcher; }

    # ── Développement & IDEs ────────────────────────────────────
    { hosts = all; package = zed-editor; }
    { hosts = all; package = code-cursor; }
    { hosts = all; package = jetbrains.idea; }
    { hosts = all; package = jetbrains.rust-rover; }
    { hosts = all; package = antigravity-cli; }
    { hosts = all; package = antigravity-ide; }
    {
      hosts = all;
      package = inputs.chatgpt-desktop.packages.${stdenv.hostPlatform.system}.default;
    }
    {
      hosts = all;
      package = inputs.codex-cli.packages.${stdenv.hostPlatform.system}.default;
    }
    {
      hosts = all;
      package = inputs.grok-bot.packages.${stdenv.hostPlatform.system}.default;
    }

    # Compilateurs, Runtimes & Moteurs
    { hosts = all; package = jdk21; }
    { hosts = all; package = maven; }
    { hosts = all; package = gradle; }
    { hosts = all; package = bun; }
    { hosts = all; package = nodejs_22; }
    { hosts = all; package = rustup; }
    { hosts = all; package = gcc; }
    { hosts = all; package = gnumake; }
    { hosts = all; package = godot_4; }

    # ── Utilitaires CLI & Système ───────────────────────────────
    { hosts = all; package = gh; }
    { hosts = all; package = nvd; }
    { hosts = all; package = nixpkgs-review; }
    { hosts = all; package = nix-output-monitor; }
    { hosts = all; package = ripgrep; }
    { hosts = all; package = fd; }
    { hosts = all; package = jq; }
    { hosts = all; package = fastfetch; }
    { hosts = all; package = socat; }
    { hosts = all; package = netcat-openbsd; }
    { hosts = all; package = age; }
    { hosts = all; package = p7zip; }
    { hosts = all; package = unzip; }
    { hosts = all; package = rsync; }

    # ── Wayland & Hyprland ──────────────────────────────────────
    { hosts = all; package = brightnessctl; }
    { hosts = all; package = playerctl; }
    { hosts = all; package = wl-clipboard; }
    { hosts = all; package = hyprpicker; }
    { hosts = all; package = wlsunset; }
    { hosts = all; package = libnotify; }
  ];
in
{
  home.packages = pickForHost hostName declarations;
}
