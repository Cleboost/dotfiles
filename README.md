# cleboost's NixOS dotfiles

Un seul dépôt, plusieurs machines NixOS + Home Manager.

| Hôte | Rôle |
| --- | --- |
| **cleboost-sage** | Laptop actuel (AMD + NVIDIA PRIME, ASUS fans, Flipper, …) |
| **cleboost-brain** | Futur PC (config matérielle à générer à l’install) |

## Repo layout

```
.
├── flake.nix                      # nixosConfigurations.<hostname> pour chaque hôte
├── lib/hosts.nix                # Liste des hôtes connus
├── hosts/
│   ├── common.nix               # Système partagé (desktop, gaming, NH, locale, …)
│   ├── cleboost-sage/
│   │   ├── default.nix          # Options propres au laptop
│   │   ├── hardware-configuration.nix
│   │   └── asus-fan-control.nix
│   └── cleboost-brain/
│       ├── default.nix          # Options propres au futur PC
│       └── hardware-configuration.nix  # Placeholder → remplacer après install
├── modules/                     # Modules système réutilisables
└── home/
    ├── default.nix              # Home Manager commun
    ├── hosts/
    │   ├── cleboost-sage.nix    # Ex. gpu-env NVIDIA/PRIME
    │   └── cleboost-brain.nix   # Extensions brain (vide pour l’instant)
    └── modules/                 # shell, hyprland, apps, …
```

## Global vs par machine

- **Global (tous les PC)** : `hosts/common.nix`, `modules/*` importés depuis common, et la plupart de `home/modules/*` + `home/default.nix`.
- **Système par hôte** : `hosts/<hostname>/default.nix` (+ `hardware-configuration.nix`).
- **Home par hôte** : `home/hosts/<hostname>.nix` (importé via `hostName` passé par le flake).

Pour une option NixOS uniquement sur sage :

```nix
# hosts/cleboost-sage/default.nix
hardware.flipperzero.enable = true;
```

Pour Home Manager uniquement sur brain :

```nix
# home/hosts/cleboost-brain.nix
{ pkgs, ... }: {
  home.packages = [ pkgs.some-tool ];
}
```

### Apps utilisateur (paquets Home Manager)

Dans `home/modules/packages.nix`, chaque app a un champ `hosts` :

| `hosts` | Effet |
| --- | --- |
| `"all"` | sage **et** brain |
| `[ "cleboost-sage" ]` | laptop seulement |
| `[ "cleboost-brain" ]` | tour seulement |

Exemple : `scrcpy` uniquement sur le laptop (téléphone branché en USB) :

```nix
{ hosts = sage; package = scrcpy; }
```

Filtre : `lib/home-packages.nix` (`pickForHost`). Pour du one-shot, `home/hosts/<hostname>.nix` reste ok.

Ajouter une machine : entrer le hostname dans `lib/hosts.nix`, créer `hosts/<name>/` et `home/hosts/<name>.nix`.

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
4. `home/hosts/cleboost-brain.nix` pour le user (GPU env, apps, etc.).
5. `sudo hostnamectl set-hostname cleboost-brain` puis `nh os switch /home/cleboost/dotfiles`.

## Desktop stack (commun)

Hyprland + Umbriel, Noctalia, greetd, Kitty, Fish, flakes `nixos-unstable`.

Voir les modules dans `modules/desktop.nix`, `home/modules/hyprland.nix`, etc.

## License

Config perso — à tes risques.
