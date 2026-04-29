if status is-interactive
    set fish_greeting

    starship init fish | source
    fastfetch

    alias pamcan="pacman"
    alias please="sudo"

    alias ls='eza --icons --group-directories-first'
    alias ll='eza -alF --icons --group-directories-first'

    alias clear="printf '\033[2J\033[3J\033[1;1H' && fastfetch --config hypr"

    alias update="yay"
end
export PATH="$HOME/.local/bin:$PATH"
