# Ventilo NVIDIA sur Hyprland — Coolbits + xhost + nvidia-settings (root).
{
  lib,
  pkgs,
  nvidiaSmi,
  nvidiaSettings ? pkgs.nvidia-settings,
}:

pkgs.writeShellScriptBin "gpu-fan" ''
  set -euo pipefail

  DISPLAY="''${DISPLAY:-:0}"
  export DISPLAY

  usage() {
    cat <<EOF
Usage: gpu-fan <0-100|auto|status>

  100       ventilo manuel à 100 %
  50        ventilo manuel (valeur libre 23–100)
  auto      rend la main au pilote
  status    temp + vitesse actuelle

Hyprland/Wayland : utilise xhost + sudo (wheel sans mot de passe sur brain).
EOF
  }

  allow_root_x() {
    ${pkgs.xorg.xhost}/bin/xhost si:localuser:root >/dev/null 2>&1 || true
  }

  case "''${1:-}" in
    -h|--help|help|"")
      usage
      exit 0
      ;;
    status)
      ${nvidiaSettings}/bin/nvidia-settings -q '[gpu:0]/GPUFanControlState' \
        -q '[fan:0]/GPUTargetFanSpeed' -q '[fan:0]/GPUCurrentFanSpeed' 2>/dev/null || true
      ${nvidiaSmi}/bin/nvidia-smi \
        --query-gpu=fan.speed,temperature.gpu,power.draw \
        --format=csv,noheader
      exit 0
      ;;
    auto)
      allow_root_x
      exec sudo ${nvidiaSettings}/bin/nvidia-settings -a "[gpu:0]/GPUFanControlState=0"
      ;;
    *)
      if ! [[ "''${1}" =~ ^[0-9]+$ ]] || [ "''${1}" -lt 23 ] || [ "''${1}" -gt 100 ]; then
        echo "gpu-fan: argument inconnu ou hors plage 23–100: ''${1}" >&2
        usage >&2
        exit 1
      fi
      allow_root_x
      exec sudo ${nvidiaSettings}/bin/nvidia-settings \
        -a "[gpu:0]/GPUFanControlState=1" \
        -a "[fan:0]/GPUTargetFanSpeed=''${1}"
      ;;
  esac
''
