#!/usr/bin/env bash
# Shared braille spinner for rebuild / update (source from ~/.local/bin)

SPINNER_FRAMES=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")

# Filter noisy nh / nixos-rebuild lines from captured logs
nh_quiet_filter() {
  grep -v -E '(Checking switch inhibitors|Skipping "/boot|activating the configuration|setting up /etc|reloading user units|restarting user units|restarting sysinit|the following new units)'
}

run_spinner() {
  local pid=$1
  local msg=$2
  local log_file=$3
  local start_time
  start_time=$(date +%s)

  tput civis 2>/dev/null || true

  while kill -0 "$pid" 2>/dev/null; do
    local now elapsed frame_idx frame
    now=$(date +%s)
    elapsed=$((now - start_time))
    frame_idx=$(( (now * 10 + $(date +%N | cut -c1-2 | sed 's/^0//')) / 10 % 10 ))
    frame=${SPINNER_FRAMES[$frame_idx]:-⠋}

    if grep -q -E "(Mot de passe|Password|sudo)" "$log_file" 2>/dev/null; then
      break
    fi

    printf "\r${CYAN}${frame}${RESET} ${DIM}${msg}...${RESET} ${CYAN}[${elapsed}s]${RESET}  "
    sleep 0.08
  done

  tput cnorm 2>/dev/null || true
  printf "\r\033[K"
}
