# Phone microphone via scrcpy → virtual PulseAudio/PipeWire source (PhoneMic).
#
# Flow: scrcpy captures Android mic → plays into null sink "phone_audio" →
# monitor remapped as input device "PhoneMic" for Discord, Steam, etc.
{ pkgs, ... }:

let
  stateFile = "$XDG_RUNTIME_DIR/phonemic-pactl-modules";

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

      printf '%s %s\n' "$sink_mod" "$src_mod" > ${stateFile}
      echo "PhoneMic prêt — sélectionne « PhoneMic » comme micro dans ton app."
    '';
  };

  phonemicStart = pkgs.writeShellApplication {
    name = "phonemic-start";
    runtimeInputs = with pkgs; [ pulseaudio scrcpy phonemicSetup ];
    text = ''
      set -euo pipefail

      phonemic-setup

      echo "Démarrage scrcpy (micro téléphone) → PhoneMic…"
      echo "Ctrl+C pour arrêter. Puis: phonemic-stop pour retirer le micro virtuel."
      export PULSE_SINK=phone_audio
      exec scrcpy \
        --no-video-playback \
        --audio-source=mic \
        --require-audio \
        "$@"
    '';
  };

  phonemicStop = pkgs.writeShellApplication {
    name = "phonemic-stop";
    runtimeInputs = with pkgs; [ pulseaudio ];
    text = ''
      set -euo pipefail

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
