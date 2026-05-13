# Fish completion for noctalia msg

function __fish_noctalia_needs_command
    set -l cmd (commandline -opc)
    if test (count $cmd) -eq 1
        return 0
    end
    return 1
end

function __fish_noctalia_msg_needs_subcommand
    set -l cmd (commandline -opc)
    if test (count $cmd) -eq 2
        if test "$cmd[2]" = "msg"
            return 0
        end
    end
    return 1
end

# Base command
complete -c noctalia -f -n "__fish_noctalia_needs_command" -a msg -d "Send a message to noctalia shell"

# Subcommands for 'noctalia msg'
complete -c noctalia -f -n "__fish_noctalia_msg_needs_subcommand" -a bar-hide -d "Hide the bar"
complete -c noctalia -f -n "__fish_noctalia_msg_needs_subcommand" -a bar-show -d "Show the bar"
complete -c noctalia -f -n "__fish_noctalia_msg_needs_subcommand" -a bar-toggle -d "Toggle bar visibility"
complete -c noctalia -f -n "__fish_noctalia_msg_needs_subcommand" -a brightness-down -d "Decrease brightness"
complete -c noctalia -f -n "__fish_noctalia_msg_needs_subcommand" -a brightness-set -d "Set brightness"
complete -c noctalia -f -n "__fish_noctalia_msg_needs_subcommand" -a brightness-up -d "Increase brightness"
complete -c noctalia -f -n "__fish_noctalia_msg_needs_subcommand" -a caffeine-disable -d "Disable caffeine"
complete -c noctalia -f -n "__fish_noctalia_msg_needs_subcommand" -a caffeine-enable -d "Enable caffeine"
complete -c noctalia -f -n "__fish_noctalia_msg_needs_subcommand" -a caffeine-toggle -d "Toggle caffeine"
complete -c noctalia -f -n "__fish_noctalia_msg_needs_subcommand" -a config-reload -d "Reload the config file"
complete -c noctalia -f -n "__fish_noctalia_msg_needs_subcommand" -a desktop-widgets-edit -d "Open the desktop widgets editor"
complete -c noctalia -f -n "__fish_noctalia_msg_needs_subcommand" -a desktop-widgets-exit -d "Close the desktop widgets editor"
complete -c noctalia -f -n "__fish_noctalia_msg_needs_subcommand" -a desktop-widgets-toggle-edit -d "Toggle desktop widgets edit mode"
complete -c noctalia -f -n "__fish_noctalia_msg_needs_subcommand" -a dock-hide -d "Hide the dock"
complete -c noctalia -f -n "__fish_noctalia_msg_needs_subcommand" -a dock-reload -d "Reload dock configuration"
complete -c noctalia -f -n "__fish_noctalia_msg_needs_subcommand" -a dock-show -d "Show the dock"
complete -c noctalia -f -n "__fish_noctalia_msg_needs_subcommand" -a dock-toggle -d "Toggle dock visibility"
complete -c noctalia -f -n "__fish_noctalia_msg_needs_subcommand" -a dpms-off -d "Turn monitors off"
complete -c noctalia -f -n "__fish_noctalia_msg_needs_subcommand" -a dpms-on -d "Turn monitors on"
complete -c noctalia -f -n "__fish_noctalia_msg_needs_subcommand" -a media -d "Control active media playback"
complete -c noctalia -f -n "__fish_noctalia_msg_needs_subcommand" -a mic-mute -d "Toggle microphone mute"
complete -c noctalia -f -n "__fish_noctalia_msg_needs_subcommand" -a mic-volume-down -d "Decrease microphone volume"
complete -c noctalia -f -n "__fish_noctalia_msg_needs_subcommand" -a mic-volume-set -d "Set microphone volume"
complete -c noctalia -f -n "__fish_noctalia_msg_needs_subcommand" -a mic-volume-up -d "Increase microphone volume"
complete -c noctalia -f -n "__fish_noctalia_msg_needs_subcommand" -a nightlight-disable -d "Disable night light schedule"
complete -c noctalia -f -n "__fish_noctalia_msg_needs_subcommand" -a nightlight-enable -d "Enable night light schedule"
complete -c noctalia -f -n "__fish_noctalia_msg_needs_subcommand" -a nightlight-force-toggle -d "Toggle forced night light mode"
complete -c noctalia -f -n "__fish_noctalia_msg_needs_subcommand" -a nightlight-toggle -d "Toggle night light schedule"
complete -c noctalia -f -n "__fish_noctalia_msg_needs_subcommand" -a notification-clear-active -d "Dismiss all currently active notifications"
complete -c noctalia -f -n "__fish_noctalia_msg_needs_subcommand" -a notification-clear-history -d "Clear notification history"
complete -c noctalia -f -n "__fish_noctalia_msg_needs_subcommand" -a notification-dnd-set -d "Set Do Not Disturb state"
complete -c noctalia -f -n "__fish_noctalia_msg_needs_subcommand" -a notification-dnd-status -d "Print Do Not Disturb state"
complete -c noctalia -f -n "__fish_noctalia_msg_needs_subcommand" -a notification-dnd-toggle -d "Toggle Do Not Disturb state"
complete -c noctalia -f -n "__fish_noctalia_msg_needs_subcommand" -a panel-toggle -d "Toggle a panel by id"
complete -c noctalia -f -n "__fish_noctalia_msg_needs_subcommand" -a power-set -d "Set the UPower power profile"
complete -c noctalia -f -n "__fish_noctalia_msg_needs_subcommand" -a power-cycle -d "Cycle through power profiles"
complete -c noctalia -f -n "__fish_noctalia_msg_needs_subcommand" -a screen-lock -d "Lock the session"
complete -c noctalia -f -n "__fish_noctalia_msg_needs_subcommand" -a scripted-widget -d "Dispatch an event to a scripted bar widget"
complete -c noctalia -f -n "__fish_noctalia_msg_needs_subcommand" -a settings-toggle -d "Toggle the settings window"
complete -c noctalia -f -n "__fish_noctalia_msg_needs_subcommand" -a status -d "Print current state as JSON"
complete -c noctalia -f -n "__fish_noctalia_msg_needs_subcommand" -a suspend -d "Suspend the system"
complete -c noctalia -f -n "__fish_noctalia_msg_needs_subcommand" -a theme-mode-set -d "Set theme mode"
complete -c noctalia -f -n "__fish_noctalia_msg_needs_subcommand" -a theme-mode-toggle -d "Toggle theme mode"
complete -c noctalia -f -n "__fish_noctalia_msg_needs_subcommand" -a theme-wallpaper-scheme-set -d "Set wallpaper palette generation scheme"
complete -c noctalia -f -n "__fish_noctalia_msg_needs_subcommand" -a volume-down -d "Decrease speaker volume"
complete -c noctalia -f -n "__fish_noctalia_msg_needs_subcommand" -a volume-mute -d "Toggle speaker mute"
complete -c noctalia -f -n "__fish_noctalia_msg_needs_subcommand" -a volume-set -d "Set speaker volume"
complete -c noctalia -f -n "__fish_noctalia_msg_needs_subcommand" -a volume-up -d "Increase speaker volume"
complete -c noctalia -f -n "__fish_noctalia_msg_needs_subcommand" -a wallpaper-random -d "Switch to a random wallpaper"
# wallpaper-set needs files, so no -f here
complete -c noctalia -n "__fish_noctalia_msg_needs_subcommand" -a wallpaper-set -d "Set wallpaper"

# Specific arguments for some subcommands
complete -c noctalia -f -n "__fish_seen_subcommand_from media" -a "next previous toggle"
complete -c noctalia -f -n "__fish_seen_subcommand_from theme-mode-set" -a "dark light auto"
complete -c noctalia -f -n "__fish_seen_subcommand_from power-set" -a "performance balanced power-saver"
complete -c noctalia -f -n "__fish_seen_subcommand_from notification-dnd-set" -a "on off true false 1 0"
complete -c noctalia -f -n "__fish_seen_subcommand_from panel-toggle" -a "launcher clipboard control-center session wallpaper"
