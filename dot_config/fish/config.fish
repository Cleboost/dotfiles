if status is-interactive
    # Supprime le message de bienvenue par défaut de fish
    set fish_greeting

    # Initialise Starship (Ton prompt stylé)
    starship init fish | source
    fastfetch --config hypr

    # --- ALIAS ---
    
    # Correction automatique des fautes de frappe courantes
    alias pamcan="pacman"
    alias please="sudo"

    alias ls='eza --icons --group-directories-first'
    alias ll='eza -alF --icons --group-directories-first'

    alias clear="printf '\033[2J\033[3J\033[1;1H' && fastfetch --config hypr"

    alias update="yay"
end
export PATH="$HOME/.local/bin:$PATH"
