{ config, lib, ... }:

lib.mkIf (lib.elem "dev" config.cleboost.groups) {
  programs.zed-editor = {
    enable = true;

    userSettings = {
      language_models = {
        openai_compatible = {
          "NIM Nvidia" = {
            api_url = "https://integrate.api.nvidia.com/v1";
            available_models = [
              {
                name = "moonshotai/kimi-k3";
                display_name = "Kimi K3";
                max_tokens = 16384;
                max_output_tokens = 32768;
                max_completion_tokens = 32768;
                capabilities = {
                  tools = true;
                  images = true;
                  parallel_tool_calls = true;
                  prompt_cache_key = false;
                  chat_completions = true;
                  interleaved_reasoning = true;
                };
              }
              {
                name = "deepseek-ai/deepseek-v4.1-flash";
                display_name = "DeepSeek V4.1 Flash";
                max_tokens = 16384;
                max_output_tokens = 32768;
                max_completion_tokens = 32768;
                capabilities = {
                  tools = true;
                  images = false;
                  parallel_tool_calls = true;
                  prompt_cache_key = false;
                  chat_completions = true;
                  interleaved_reasoning = false;
                };
              }
            ];
          };
        };
      };

      proxy = "";
      restore_on_startup = "last_workspace";
      cli_default_open_behavior = "existing_window";

      project_panel = {
        dock = "left";
      };
      outline_panel = {
        dock = "left";
      };
      collaboration_panel = {
        dock = "left";
      };
      git_panel = {
        dock = "left";
      };

      agent = {
        default_model = {
          provider = "NIM Nvidia";
          model = "moonshotai/kimi-k2.6";
          enable_thinking = false;
        };
        commit_message_model = {
          model = "deepseek-ai/deepseek-v4.1-flash";
          provider = "NIM Nvidia";
          enable_thinking = false;
        };
        commit_message_instructions = ''
          Generate a Git commit message following the Conventional Commits specification.

          Requirements:
          - Write everything in English.
          - Use the format: <type>(<scope>): <short imperative summary>
          - If the change is significant, add a blank line followed by bullet points describing the key changes.
          - Keep the summary under 72 characters.
          - Use the imperative mood (e.g. add, fix, refactor, remove).
          - Do not mention files unless necessary.
          - Group related changes instead of listing every modified file.
          - Focus on the intent and impact of the change.
          - If the change is trivial (formatting, dependency bump, typo, etc.), output only the summary line.
          - Do not wrap the message in code fences.
          - Output only the commit message.

          Use Conventional Commit types when appropriate: feat, fix, refactor, perf, docs, style, test, build, ci, chore, revert.
        '';
        dock = "right";
        favorite_models = [ ];
        model_parameters = [ ];
      };

      edit_predictions = {
        provider = "open_ai_compatible_api";
        open_ai_compatible_api = {
          api_url = "https://integrate.api.nvidia.com/v1/";
          model = "deepseek-ai/deepseek-v4.1-flash";
        };
      };

      agent_servers = {
        kilo = {
          type = "registry";
          default_config_options = {
            model = "kilo/kilo-auto/free";
          };
        };
        github-copilot-cli = {
          type = "registry";
        };
        cursor = {
          type = "registry";
        };
        claude-acp = {
          type = "registry";
          favorite_config_option_values = {
            effort = [ "low" ];
            model = [ "sonnet" ];
          };
          default_config_options = {
            mode = "bypassPermissions";
            effort = "low";
            model = "sonnet";
          };
        };
      };

      icon_theme = {
        mode = "dark";
        light = "Zed (Default)";
        dark = "Zed (Default)";
      };

      ui_font_size = 16;
      buffer_font_size = 15;

      theme = {
        mode = "dark";
        light = "One Light";
        dark = "Ayu Dark";
      };
    };
  };

  xdg.mimeApps.defaultApplications = {
    "x-scheme-handler/jetbrains" = "jetbrainsd.desktop";
    "text/plain" = "dev.zed.Zed.desktop";
    "application/toml" = "dev.zed.Zed.desktop";
  };
}
