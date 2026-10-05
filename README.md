# cleboost's NixOS dotfiles

Un seul dépôt, plusieurs machines NixOS + Home Manager.

| Hôte | Rôle |
| --- | --- |
| **cleboost-sage** | Laptop actuel (AMD + NVIDIA PRIME, ASUS fans, Flipper, …) |
| **cleboost-brain** | Futur PC (config matérielle à générer à l’install) |

## Organisation

Trois dossiers, une seule règle : **chaque `.nix` est rangé avec les fichiers de config qu’il utilise.**

```
.
├── flake.nix                  # Liste des machines + inputs
│
├── hosts/                     # Ce qui est propre à UNE machine
│   ├── cleboost-sage/
│   │   ├── default.nix        # Système (kernel, nvidia, flipper, …)
│   │   ├── home.nix           # Utilisateur (apps en plus, …)
│   │   ├── hardware-configuration.nix
│   │   ├── asus-fan-control.nix
│   │   └── gpu-env.nix        # Variables PRIME NVIDIA/AMD
│   └── cleboost-brain/
│       ├── default.nix
│       ├── home.nix
│       └── hardware-configuration.nix
│
├── nixos/                     # Système commun à toutes les machines
│   ├── default.nix            # Nix, boot, locale, user, …
│   ├── desktop.nix  gaming.nix  docker.nix
│   ├── keyring.nix  noctalia.nix  packages.nix
│   └── nvidia.nix             # Importé seulement par les machines NVIDIA
│
└── home/                      # Utilisateur commun à toutes les machines
    ├── default.nix            # Point d’entrée, dossiers XDG
    ├── packages/              # Apps : gui, dev, cli, wayland
    ├── shell/                 # fish, git, starship, btop, fastfetch
    ├── kitty/
    ├── hyprland/
    ├── umbriel/
    ├── theme/                 # GTK, Qt, icônes, curseur, fonds d’écran
    ├── apps/                  # Apps par défaut (MIME) + configs zed, noctalia, mangohud, …
    ├── secrets.nix            # gnome-keyring
    └── bin/                   # Scripts → ~/.local/bin
```

## Où mettre quoi

| Je veux… | Fichier |
| --- | --- |
| Une app sur les deux machines | `home/packages/gui.nix` (ou `dev`, `cli`, `wayland`) |
| Une app sur une seule machine | `home.packages` dans `hosts/<machine>/home.nix` |
| Une option système partout | `nixos/default.nix` ou le module qui correspond |
| Une option système sur une machine | `hosts/<machine>/default.nix` |
| Modifier la config d’un programme | son dossier dans `home/` (ex. `home/hyprland/`) |
| Ajouter un script perso | `home/bin/` |

Exemple, une app uniquement sur le laptop :

```nix
# hosts/cleboost-sage/home.nix
home.packages = with pkgs; [
  scrcpy
];
```

Ajouter une machine : ajouter son nom dans `hosts` de `flake.nix`, puis créer `hosts/<nom>/` avec `default.nix`, `home.nix` et `hardware-configuration.nix`.

## Usage

Le hostname système doit correspondre à une entrée du flake (`cleboost-sage` ou `cleboost-brain`).

```bash
nh os switch /home/cleboost/dotfiles
rebuild          # Home Manager (rapide)
rebuild -s       # NixOS complet
```

Build explicite :

```bash
nix build .#nixosConfigurations.cleboost-sage.config.system.build.toplevel
```

## Migration cleboost-sage (ce PC)

1. `sudo hostnamectl set-hostname cleboost-sage`
2. `nh os switch /home/cleboost/dotfiles` (ou `rebuild -s`)
3. Redémarrer si besoin (greeter, réseau, etc.)

## Migration cleboost-brain (nouveau PC)

1. Installer NixOS, cloner ce repo.
2. `sudo nixos-generate-config --show-hardware-config` → remplacer `hosts/cleboost-brain/hardware-configuration.nix`.
3. Ajuster `hosts/cleboost-brain/default.nix` (GPU, disques, packages système, …).
4. `hosts/cleboost-brain/home.nix` pour le user (GPU env, apps, …).
5. `sudo hostnamectl set-hostname cleboost-brain` puis `nh os switch /home/cleboost/dotfiles`.

## Desktop stack (commun)

Hyprland + Umbriel, Noctalia, greetd, Kitty, Fish, flakes `nixos-unstable`.

## License

Config perso — à tes risques.
