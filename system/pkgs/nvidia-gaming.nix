# Toggle jeu : ventilo 100 % + power limit 300 W ⟷ défaut.
{ pkgs, nvidiaSmi, powerLimitW ? 300 }:

pkgs.writeShellScriptBin "nvidia-gaming" ''
  set -euo pipefail

  DISPLAY="''${DISPLAY:-:0}"
  export DISPLAY

  STATE_DIR="''${XDG_STATE_HOME:-$HOME/.local/state}"
  STATE_FILE="''${STATE_DIR}/nvidia-gaming"
  PL_GAME=''${PL_GAME:-${toString powerLimitW}}

  mkdir -p "''${STATE_DIR}"

  read_default_pl() {
    ${nvidiaSmi}/bin/nvidia-smi --query-gpu=power.default_limit \
      --format=csv,noheader,nounits -i 0 | head -1 | tr -d ' '
  }

  if [[ -f "''${STATE_FILE}" ]]; then
    saved=$(cat "''${STATE_FILE}")
    gpu-fan auto
    sudo ${nvidiaSmi}/bin/nvidia-smi -pl "''${saved}" -i 0
    rm -f "''${STATE_FILE}"
    echo "nvidia-gaming: désactivé — PL ''${saved} W, ventilo auto"
  else
    saved=$(read_default_pl)
    echo "''${saved}" > "''${STATE_FILE}"
    gpu-fan 100
    sudo ${nvidiaSmi}/bin/nvidia-smi -pl "''${PL_GAME}" -i 0
    echo "nvidia-gaming: activé — PL ''${PL_GAME} W, ventilo 100 %"
  fi
''
