-- CodeCompanion: Cursor-like AI coding assistant for Neovim
-- Provides inline editing, chat interface, and agentic workflows with Claude
--
-- NOTE: Consider migrating to sidekick.nvim (by Folke) in the future once it matures.
--       Sidekick offers more modern architecture with sophisticated diff system,
--       Next Edit Suggestions (NES), and character/word-level granular diffing.
--       https://github.com/folke/sidekick.nvim
--       Requires Neovim 0.11.2+ (uses latest features)
--
-- Current choice: codecompanion.nvim
-- - Better maintained (v17.30.0+, only 1 open issue vs Avante's 203)
-- - Maintains conversation history (unlike Avante)
-- - Excellent Claude support with ACP integration
-- - Well-documented with active development

return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-telescope/telescope.nvim", -- Optional: for slash command selection
    "stevearc/dressing.nvim", -- Optional: improves UI
  },
  config = function()
    local keymaps = require "eric.keymaps"

    require("codecompanion").setup {
      adapters = {
        http = {
          -- Anthropic/Claude adapter with custom API key script
          anthropic = function()
            return require("codecompanion.adapters").extend("anthropic", {
              env = {
                -- Read API key from your existing shell script
                api_key = "cmd:~/.claude/anthropic_key.sh",
              },
              schema = {
                model = {
                  default = "claude-sonnet-4-5-20250929",
                  -- Other options: claude-opus-4, claude-haiku-4-5, etc.
                },
              },
            })
          end,

          -- Custom API endpoint wrapper (for your local wrapper script)
          -- Uncomment and configure if you need to use a custom wrapper
          -- anthropic_custom = function()
          --   return require("codecompanion.adapters").extend("anthropic", {
          --     env = {
          --       api_key = "cmd:~/.claude/anthropic_key.sh",
          --       -- Custom endpoint for wrapper script
          --       url = "http://localhost:8080/v1/messages", -- Change to your wrapper URL
          --     },
          --     headers = {
          --       ["Authorization"] = "Bearer ${api_key}",
          --       ["anthropic-version"] = "2023-06-01",
          --       ["X-Working-Dir"] = vim.fn.getcwd(), -- Pass current working directory
          --     },
          --     schema = {
          --       model = {
          --         default = "claude-sonnet-4-5-20250929",
          --       },
          --     },
          --   })
          -- end,
        },

        -- Agent Client Protocol (ACP) configuration
        -- NOTE: Claude Code does not yet support ACP as of January 2025
        -- Configuration is ready for when it becomes available
        -- acp = {
        --   claude_code = function()
        --     return require("codecompanion.adapters").extend("claude_code", {
        --       env = {
        --         CLAUDE_CODE_OAUTH_TOKEN = "cmd:~/.claude/oauth_token.sh",
        --       },
        --     })
        --   end,
        -- },
      },

      -- Strategy configuration
      strategies = {
        chat = {
          adapter = "anthropic",
          keymaps = keymaps.get_codecompanion_chat_keys(),
          opts = {
            -- Blink.cmp integration for chat completion
            completion_provider = "blink", -- Options: blink|cmp|coc|default

            -- System prompt for Claude
            system_prompt = [[You are an AI programming assistant integrated into Neovim.
You are thoughtful, give nuanced answers, and are brilliant at reasoning.
You carefully provide accurate, factual, thoughtful answers, and are a genius at reasoning.

- Follow the user's requirements carefully & to the letter.
- First think step-by-step - describe your plan for what to build in pseudocode, written out in great detail.
- Confirm, then write code!
- Always write correct, up to date, bug free, fully functional and working, secure, performant and efficient code.
- Focus on readability over being performant.
- Fully implement all requested functionality.
- Leave NO todo's, placeholders or missing pieces.
- Be concise. Minimize any other prose.
- If you think there might not be a correct answer, you say so. If you do not know the answer, say so instead of guessing.]],

            -- Enable slash commands
            slash_commands = {
              ["buffer"] = {
                opts = {
                  provider = "default",
                },
              },
              ["file"] = {
                opts = {
                  provider = "telescope",
                },
              },
              ["help"] = {
                opts = {
                  provider = "telescope",
                },
              },
              ["symbols"] = {
                opts = {
                  provider = "telescope",
                },
              },
            },

            -- Memory files for Cursor-like behavior
            -- These files will be automatically read for project-specific instructions
            memory_files = {
              "CLAUDE.md",
              ".cursor/rules",
              ".cursorrules",
              "INSTRUCTIONS.md",
            },
          },
        },

        inline = {
          adapter = "anthropic",
          keymaps = keymaps.get_codecompanion_inline_keys(),
        },

        -- Command strategy (for Neovim commands)
        cmd = {
          adapter = "anthropic",
        },
      },

      -- Display settings
      display = {
        action_palette = {
          width = 95,
          height = 10,
        },
        chat = {
          window = {
            layout = "vertical", -- vertical|horizontal|float|buffer
            border = "rounded",
            height = 0.8,
            width = 0.45,
            relative = "editor",
            opts = {
              breakindent = true,
              cursorcolumn = false,
              cursorline = false,
              foldcolumn = "0",
              linebreak = true,
              signcolumn = "no",
              spell = false,
              wrap = true,
            },
          },
          show_settings = true,
          show_token_count = true,
          start_in_insert_mode = true,
        },
        inline = {
          -- Diff configuration for inline editing
          diff = {
            enabled = true,
            close_chat_at = 240, -- Close chat after X seconds of no activity
            layout = "vertical", -- vertical|horizontal|buffer
            opts = { "internal", "filler", "closeoff", "algorithm:patience", "followwrap", "linematch:120" },
            priority = 130,
          },
        },
      },

      -- Prompt library (add your own custom prompts here)
      prompt_library = {
        ["Code Review"] = {
          strategy = "chat",
          description = "Review code for best practices and potential issues",
          opts = {
            mapping = "<LocalLeader>cr",
            modes = { "v" },
            slash_cmd = "review",
            auto_submit = true,
            user_prompt = false,
          },
          prompts = {
            {
              role = "system",
              content = "You are an expert code reviewer. Analyze code for bugs, security issues, performance problems, and best practices.",
            },
            {
              role = "user",
              content = function(context)
                return "Please review this code:\n\n```" .. context.filetype .. "\n" .. context.selection .. "\n```"
              end,
            },
          },
        },
      },

      -- Options
      opts = {
        log_level = "INFO", -- TRACE|DEBUG|INFO|WARN|ERROR
        send_code = true,
        use_default_actions = true,
        use_default_prompt_library = true,
      },
    }
  end,
}
