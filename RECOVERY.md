# 2026-10-01 rollback — what to recover later

Clean state on `main`: commit **`f936334`** + nixpkgs **`7a0f122`** (aligned with NixOS gen **162** / **169**).

## Backup branches (keep until cherry-picked)

| Branch | Contents |
| --- | --- |
| `backup/2026-10-01` | `f936334` + archived greeter/qt6ct fix (`c30c5c8`) |
| `backup/desktop-env-refactor` | Commit `0fd00c7` (desktop-env, mk-gpu-env, noctalia sage fragments, …) |
| `backup/brain-preconfig` | Commit `415e17c` (brain NVIDIA stack) |
| `backup/flake-bump-oct1` | Commit `b7f06b5` (lockfile → nixpkgs **`c59305b`**, gen **167** broke greeter) |

## Git stash

- `stash@{0}` (if present): WIP “before reset” — `git stash list` then `git stash show -p`

## Reflog

`git reflog` to find other pointers if needed.

## What broke the machine (do not re-apply in one shot)

1. Bump nixpkgs **`c59305b`** without validating greeter/PRIME on sage.
2. HM refactor **`0fd00c7`** + `hypr/core` / `qt6ct` migration (HM conflicts + store symlinks).
3. `nh os switch` on a **dirty** tree without reboot tests in between.

## Suggested re-apply order

1. Cherry-pick or merge from `backup/2026-10-01` (`nixos/nvidia.nix`, `nixos/noctalia.nix`, qt6ct `force`).
2. `nh os switch` → reboot → greeter OK.
3. Only then: pieces from `backup/desktop-env-refactor`.
