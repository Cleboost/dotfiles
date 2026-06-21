set -gx PATH "$HOME/.local/bin" $PATH
set -gx SSH_AUTH_SOCK "$HOME/.bitwarden-ssh-agent.sock"


if status is-interactive
    set fish_greeting

    starship init fish | source
    fastfetch-random

    alias pamcan="pacman"
    alias please="sudo"

    alias ls='eza --icons --group-directories-first'
    alias ll='eza -alF --icons --group-directories-first'

    alias clear="printf '\033[2J\033[3J\033[1;1H' && fastfetch-random"

    alias update="yay --noconfirm -Syu"
    alias sync-ssh="sync-ssh-pubkeys.sh"
end
