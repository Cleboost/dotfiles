# Phone microphone via scrcpy → virtual PulseAudio/PipeWire source (PhoneMic).
#
# Flow: scrcpy captures Android mic → PipeWire link to null sink "phone_audio" →
# monitor remapped as input device "PhoneMic" for Discord, Steam, etc.
{ pkgs, ... }:

let
  stateDir = ''"$XDG_RUNTIME_DIR/phonemic"'';
  stateFile = ''"$XDG_RUNTIME_DIR/phonemic/pactl-modules"'';
  pidFile = ''"$XDG_RUNTIME_DIR/phonemic/scrcpy.pid"'';

  phonemicSetup = pkgs.writeShellApplication {
    name = "phonemic-setup";
    runtimeInputs = with pkgs; [ pulseaudio ripgrep ];
    text = ''
      set -euo pipefail

      if pactl list sources short | rg -q '^[0-9]+\s+phone_mic\s'; then
        echo "PhoneMic déjà actif."
        exit 0
      fi

      sink_mod=$(pactl load-module module-null-sink \
        sink_name=phone_audio \
        sink_properties=device.description=PhoneAudio)
      src_mod=$(pactl load-module module-remap-source \
        master=phone_audio.monitor \
        source_name=phone_mic \
        source_properties=device.description=PhoneMic)

      mkdir -p ${stateDir}
      printf '%s %s\n' "$sink_mod" "$src_mod" > ${stateFile}
      echo "PhoneMic prêt — sélectionne « PhoneMic » comme micro dans ton app."
    '';
  };

  phonemicStart = pkgs.writeShellApplication {
    name = "phonemic-start";
    runtimeInputs = with pkgs; [ pulseaudio pipewire scrcpy phonemicSetup ripgrep ];
    text = ''
      set -euo pipefail

      phonemic-setup

      wait_for_scrcpy_ports() {
        for _ in $(seq 1 80); do
          if pw-link -o 2>/dev/null | rg -q '^scrcpy:output_FL$'; then
            return 0
          fi
          sleep 0.25
        done
        return 1
      }

      route_scrcpy_to_phone_audio() {
        local ch port target

        # scrcpy 5.x uses PipeWire natively and auto-connects to speakers — retry a bit.
        for _ in 1 2 3 4 5 6 7 8; do
          for ch in FL FR; do
            pw-link "scrcpy:output_$ch" "phone_audio:playback_$ch" 2>/dev/null || true
          done

          while IFS= read -r port target; do
            pw-link -d "$port" "$target" 2>/dev/null || true
          done < <(
            pw-link -l 2>/dev/null | awk '
              /^scrcpy:output_/ { port=$1; next }
              /^[[:space:]]+\|-> / && port != "" {
                target=$NF
                if (target !~ /^phone_audio:playback_/) print port, target
              }
            '
          )

          sleep 0.3
        done
      }

      echo "Démarrage scrcpy (micro téléphone) → PhoneMic…"
      echo "Ctrl+C pour arrêter. Puis: phonemic-stop pour retirer le micro virtuel."

      mkdir -p ${stateDir}

      scrcpy \
        --no-window \
        --no-control \
        --audio-source=mic \
        --require-audio \
        --audio-buffer=200 \
        "$@" &
      scr_pid=$!
      echo "$scr_pid" > ${pidFile}

      if wait_for_scrcpy_ports && route_scrcpy_to_phone_audio; then
        echo "Audio routé vers PhoneMic (sélectionne « PhoneMic », pas « scrcpy »)."
      else
        echo "Attention: routage audio échoué — branche scrcpy → PhoneAudio dans qpwgraph/pavucontrol."
      fi

      trap 'kill "$scr_pid" 2>/dev/null || true; rm -f ${pidFile}' INT TERM
      wait "$scr_pid"
      rm -f ${pidFile}
    '';
  };

  phonemicStop = pkgs.writeShellApplication {
    name = "phonemic-stop";
    runtimeInputs = with pkgs; [ pulseaudio ];
    text = ''
      set -euo pipefail

      if [[ -f ${pidFile} ]]; then
        kill "$(cat ${pidFile})" 2>/dev/null || true
        rm -f ${pidFile}
      fi

      if [[ -f ${stateFile} ]]; then
        read -r sink_mod src_mod < ${stateFile}
        pactl unload-module "$src_mod" 2>/dev/null || true
        pactl unload-module "$sink_mod" 2>/dev/null || true
        rm -f ${stateFile}
        echo "PhoneMic retiré."
      else
        echo "Aucun module PhoneMic enregistré (déjà arrêté ou jamais lancé)."
      fi
    '';
  };
in
{
  home.packages = [
    phonemicSetup
    phonemicStart
    phonemicStop
  ];
}
