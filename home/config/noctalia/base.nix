# Noctalia commun — overlays dans hosts/<hostname>.nix.
{ home }:
{
  shell = {
    font_family = "JetBrainsMono Nerd Font";
    lang = "fr";
    avatar_path = "${home}/Pictures/profile.png";
    offline_mode = false;
    telemetry_enabled = true;
    polkit_agent = true;
    password_style = "random";
    settings_show_advanced = false;
    show_location = true;
    screen_time_enabled = true;
    corner_radius_scale = 2;
    clipboard_auto_paste = "off";
    clipboard_image_action_command = "feh {path}";
    animation = {
      enabled = true;
      speed = 1;
    };
    shadow = {
      alpha = 0.55;
    };
    mpris = {
      blacklist = [ ];
    };
    screen_corners = {
      enabled = true;
    };
    greeter_sync = {
      auto_sync = true;
    };
    screenshot = {
      directory = "${home}/Pictures/Screenshots";
    };
    session = {
      power = {
        reboot = "systemctl reboot";
        shutdown = "systemctl poweroff";
        suspend = "systemctl suspend";
      };
    };
  };
  wallpaper = {
    enabled = true;
    fill_mode = "crop";
    fill_color = "";
    transition = [
      "disc"
      "stripes"
      "zoom"
    ];
    transition_duration = 1500;
    edge_smoothness = 0.3;
    directory = "${home}/Pictures/Wallpapers";
    directory_light = "";
    directory_dark = "";
    automation = {
      enabled = false;
      order = "random";
      recursive = true;
    };
  };
  theme = {
    mode = "dark";
    source = "wallpaper";
    builtin = "Ayu";
    community_palette = "ADW";
    wallpaper_scheme = "m3-content";
    templates = {
      builtin_ids = [
        "btop"
        "gtk3"
        "gtk4"
        "hyprland"
        "kitty"
        "qt"
        "starship"
      ];
      community_ids = [ ];
    };
  };
  system = {
    monitor = {
      enabled = true;
    };
  };
  weather = {
    enabled = true;
    refresh_minutes = 30;
    unit = "celsius";
  };
  audio = {
    enable_overdrive = false;
    enable_sounds = true;
    sound_volume = 0.5;
    volume_change_sound = "";
    notification_sound = "";
  };
  brightness = {
    enable_ddcutil = false;
  };
  nightlight = {
    enabled = false;
    force = false;
    temperature_day = 6500;
    temperature_night = 4000;
  };
  notification = {
    enable_daemon = true;
    background_opacity = 0.97;
  };
  osd = {
    position = "top_right";
  };
  keybinds = {
    validate = [
      "return"
      "kp_enter"
    ];
    cancel = [
      "escape"
    ];
    left = [
      "left"
    ];
    right = [
      "right"
    ];
    up = [
      "up"
    ];
    down = [
      "down"
    ];
  };
  bar = {
    main = {
      position = "top";
      thickness = 34;
      background_opacity = 0.85;
      radius = 80;
      radius_top_left = 0;
      radius_top_right = 0;
      margin_edge = 0;
      margin_ends = 230;
      padding = 14;
      widget_spacing = 6;
      scale = 1;
      shadow = true;
      auto_hide = false;
      reserve_space = true;
      capsule = false;
      start = [
        "workspaces"
      ];
      center = [ ];
      end = [
        "tray"
        "clock"
        "control-center"
      ];
    };
  };
  widget = {
    cpu = {
      type = "sysmon";
      visualization = "gauge";
      show_value = true;
    };
    sysmon = {
      stat = "cpu_usage";
    };
    media = {
      capsule = true;
      title_scroll = "always";
    };
    ram = {
      visualization = "gauge";
      show_value = true;
    };
    recorder = {
      type = "noctalia/screen_recorder:recorder";
    };
    temp = {
      visualization = "gauge";
      show_value = true;
    };
    tray = {
      capsule = true;
      drawer = true;
      hidden = [
        "discord"
      ];
      pinned = [ ];
    };
    workspaces = {
      capsule = true;
      label_source = "name";
      show_labels = true;
    };
  };
  dock = {
    enabled = false;
    position = "bottom";
    icon_size = 48;
    item_spacing = 6;
    background_opacity = 0.88;
    radius = 16;
    shadow = true;
    show_running = true;
    auto_hide = false;
    reserve_space = false;
    active_scale = 1;
    inactive_scale = 0.85;
    active_opacity = 1;
    inactive_opacity = 0.85;
    show_instance_count = true;
    active_monitor_only = false;
    pinned = [ ];
  };
  desktop_widgets = {
    enabled = true;
    schema_version = 1;
    widget_order = [
      "desktop_clock"
      "desktop_audio_visualizer"
      "desktop_media_player"
      "desktop_weather"
    ];
    grid = {
      cell_size = 16;
      major_interval = 4;
      visible = true;
    };
    widget = {
      desktop_clock = {
        type = "clock";
        box_height = 341;
        box_width = 579;
        cx = 961.5;
        cy = 406.5;
        output = "DP-2";
        rotation = 0;
        settings = {
          background = false;
        };
      };
      desktop_audio_visualizer = {
        type = "audio_visualizer";
        box_height = 0;
        box_width = 0;
        cx = 968;
        cy = 556;
        output = "DP-2";
        rotation = 0;
        settings = {
          background = false;
          bands = 32;
          show_when_idle = true;
        };
      };
      desktop_media_player = {
        type = "media_player";
        box_height = 117.25372314453125;
        box_width = 274.1969909667969;
        cx = 160;
        cy = 998.6268310546875;
        output = "DP-2";
        rotation = 0;
        settings = {
          layout = "horizontal";
        };
      };
      desktop_weather = {
        type = "weather";
        box_height = 0;
        box_width = 0;
        cx = 118;
        cy = 892;
        output = "DP-2";
        rotation = 0;
        settings = {
          background = false;
        };
      };
    };
  };
  control_center = {
    shortcuts = [
      {
        type = "wifi";
      }
      {
        type = "bluetooth";
      }
      {
        type = "notification";
      }
      {
        type = "power_profile";
      }
    ];
  };
  plugins = {
    enabled = [
      "noctalia/bongocat"
      "noctalia/screen_recorder"
    ];
    source = [
      {
        kind = "git";
        location = "https://github.com/noctalia-dev/official-plugins";
        name = "official";
      }
      {
        kind = "git";
        location = "https://github.com/noctalia-dev/community-plugins";
        name = "community";
      }
    ];
  };
  plugin_settings = {
    "noctalia/screen_recorder" = {
      frame_rate = 144;
      video_codec = "h264";
      video_source = "focused";
    };
  };
}
