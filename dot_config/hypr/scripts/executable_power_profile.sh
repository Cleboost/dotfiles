#!/usr/bin/env bash

profiles=("power-saver" "balanced" "performance")

current=$(powerprofilesctl get)

for i in "${!profiles[@]}"; do
  if [[ "${profiles[$i]}" == "$current" ]]; then
    next_index=$(( (i + 1) % ${#profiles[@]} ))
    next="${profiles[$next_index]}"
    break
  fi
done

case "$next" in
    "power-saver") icon="battery-low" ;;
    "balanced")    icon="utilities-energy-monitor" ;;
    "performance") icon="speedometer" ;;
    *)             icon="power-mode" ;;
esac

formatted_name=$(echo "$next" | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2)} 1')

powerprofilesctl set "$next"
notify-send -r 5555 -i "$icon" "$formatted_name" "Profil d'alimentation"
