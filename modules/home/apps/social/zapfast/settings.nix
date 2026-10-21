# ZapFast settings.json — https://zapfast.rocks/settings-and-files/
#
# Runtime state (last_chat, recent_emoji, window geometry in dev builds) is reset
# on home-manager switch; ZapFast rewrites those while you use the app.
{
  version = 1;

  # Appearance
  theme = "dark";
  font = "system";
  interface_language = null;
  custom_theme = null;
  zoom = 1.0;
  sidebar_width = 320.0;
  search_pane_width = 380.0;

  # Chats
  enter_sends = true;
  send_read_receipts = true;
  send_typing = true;
  auto_download = true;
  show_wallpaper = true;
  wallpaper_color = "theme";
  dark_wallpaper_color = "theme";
  wallpaper_image = null;
  pause_other_media = true;
  save_contacts_to_phone = true;

  # Runtime — ZapFast updates these; null/empty defaults after each switch.
  last_chat = null;
  show_shortcut_hints = true;
  recent_emoji = [ ];
  reaction_emoji = [ ];

  giphy_key = "";

  # Policy
  keep_running_in_background = false;

  # Notifications
  notifications = true;
  message_sound = "receive";
  mention_sound = "alert";
  group_sounds = true;

  download_folder = null;
  proxy = "";
  check_for_updates = true;
  download_updates_automatically = false;
  voice_speed = 1.0;

  chat_lock_code_hash = null;
  chat_lock_hint_dismissed = false;
  app_lock_hash = null;
  app_lock_after = "fifteen_minutes";
}
