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

    alias gem='nohup kitty --override background_opacity=1.0 gemini >/dev/null 2>&1 &; disown; exit'
    
    # Utiliser eza à la place de ls (plus joli avec les icônes)
    # Assure-toi que le paquet 'eza' est bien installé
    alias ls='eza --icons --group-directories-first'
    alias ll='eza -alF --icons --group-directories-first'
    
    # Nettoyage propre du terminal
    alias clear="printf '\033[2J\033[3J\033[1;1H'"

    # Raccourcis utiles pour Arch
    alias update="yay"
end
export PATH="$HOME/.local/bin:$PATH"
