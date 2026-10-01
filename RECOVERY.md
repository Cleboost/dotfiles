# Rollback du 2026-10-01 — quoi récupérer plus tard

État **propre** sur `main` : commit **`f936334`** + nixpkgs **`7a0f122`** (aligné NixOS gen **162** / **169**).

## Branches de sauvegarde (ne pas supprimer tant que tu n’as pas cherry-pick)

| Branche | Contenu |
| --- | --- |
| `backup/2026-10-01` | `f936334` + fix greeter/qt6ct archivés (`c30c5c8`) |
| `backup/desktop-env-refactor` | Commit `0fd00c7` (desktop-env, mk-gpu-env, noctalia sage fragments, …) |
| `backup/brain-preconfig` | Commit `415e17c` (stack brain NVIDIA) |
| `backup/flake-bump-oct1` | Commit `b7f06b5` (lockfile → nixpkgs **`c59305b`**, gen **167** cassait greeter) |

## Stash git

- `stash@{0}` (si présent) : WIP « before reset » — `git stash list` puis `git stash show -p`

## Reflog

`git reflog` pour retrouver d’autres pointeurs si besoin.

## Ce qui a cassé le PC (à ne pas réappliquer d’un bloc)

1. Bump nixpkgs **`c59305b`** sans valider greeter PRIME sur sage.
2. Refactor HM **`0fd00c7`** + migration `hypr/core` / `qt6ct` (conflits HM + symlinks store).
3. `nh os switch` avec arbre **dirty** sans reboot test intermédiaire.

## Réappliquer proprement (ordre suggéré)

1. Cherry-pick ou merge depuis `backup/2026-10-01` (`modules/nvidia.nix`, `modules/noctalia.nix`, qt6ct `force`).
2. `nh os switch` → reboot → greeter OK.
3. Ensuite seulement : morceaux de `backup/desktop-env-refactor`.
