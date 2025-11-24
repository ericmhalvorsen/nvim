--
--
-- 1. **Initial Request**: Ask the LLM to solve a coding problem
-- 2. **Tool Usage**: Model uses @editor to modify code and @cmd_runner to test
-- 3. **Feedback Loop**: If tests fail, system auto-prompts LLM to try again
-- 4. **Completion**: Loop stops when tests pass
--
-- ## Available Tools
--
-- - @editor / @insert_edit_into_file: Modify code in files
-- - @cmd_runner: Execute shell commands and see output
-- - @full_stack_dev: Advanced development variable with project context
--
-- https://github.com/olimorris/codecompanion.nvim/discussions/877
--
-- ═══════════════════════════════════════════════════════════════════════════

return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-telescope/telescope.nvim",
    "stevearc/dressing.nvim",
  },
  config = function()
    local keymaps = require "eric.keymaps"

    require("codecompanion").setup {
      adapters = require "eric.plugins.codecompanion.adapters",

      strategies = {
        chat = {
          adapter = "anthropic",
          keymaps = keymaps.get_codecompanion_chat_keys(),
          opts = {
            completion_provider = "blink", -- Options: blink|cmp|coc|default

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

            slash_commands = require "eric.plugins.codecompanion.slash_commands",

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

        cmd = {
          adapter = "anthropic",
        },
      },

      display = {
        action_palette = {
          width = 95,
          height = 10,
        },
        chat = {
          window = {
            layout = "vertical",
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
          diff = {
            enabled = true,
            close_chat_at = 240,
            layout = "vertical",
            opts = { "internal", "filler", "closeoff", "algorithm:patience", "followwrap", "linematch:120" },
            priority = 130,
          },
        },
      },

      prompt_library = require "eric.plugins.codecompanion.prompts",

      opts = {
        log_level = "INFO", -- TRACE|DEBUG|INFO|WARN|ERROR
        send_code = true,
        use_default_actions = true,
        use_default_prompt_library = true,
      },
    }

    require("eric.plugins.codecompanion.autosave").setup {
      enabled = true,
      triggers = {
        "BufLeave",
        "FocusLost",
      },
      save_dir = "~/.local/codecompanion/",
      notify_on_save = false,
    }
  end,
}
