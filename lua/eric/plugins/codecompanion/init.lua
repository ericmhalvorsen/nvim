-- CodeCompanion: Cursor-like AI coding assistant for Neovim
-- Provides inline editing, chat interface, and agentic workflows with Claude
--
-- ═══════════════════════════════════════════════════════════════════════════
-- AGENTIC WORKFLOWS - HOW TO USE CODECOMPANION EFFECTIVELY
-- ═══════════════════════════════════════════════════════════════════════════
--
-- ## What Are Agentic Workflows?
--
-- Agentic Workflows in CodeCompanion enable automated loop systems where LLMs
-- iteratively solve problems using integrated tools without manual intervention.
--
-- ## How They Work: Edit↔Test Workflow Example
--
-- 1. **Initial Request**: Ask the LLM to solve a coding problem
-- 2. **Tool Usage**: Model uses @editor to modify code and @cmd_runner to test
-- 3. **Feedback Loop**: If tests fail, system auto-prompts LLM to try again
-- 4. **Completion**: Loop stops when tests pass
--
-- This creates a self-correcting development cycle - the LLM keeps iterating
-- until it gets it right!
--
-- ## Key Features
--
-- - **Resilient Tool Handling**: Tools handle multiple LLM invocation styles
-- - **Buffer Management**: Use #buffer{watch} and #buffer{pin} for tracking
-- - **Natural Language**: Use phrases like "run the @cmd_runner tool"
-- - **Full Buffer Replacement**: Editor tool can overwrite entire buffers
-- - **Human Safeguards**: All risky operations require approval/rejection
--
-- ## Effective Use Cases
--
-- - **Automated Testing & Debugging**: Test-driven refinement with auto-retry
-- - **Type Checking**: Iteratively fix TypeScript/LSP errors across files
-- - **Continuous Improvement**: Any task requiring repeated LLM adjustments
--
-- ## Best Practices
--
-- 1. **Use Workflows for Complex Tasks**: Multi-step operations benefit most
-- 2. **Enable Auto Tool Mode**: Set vim.g.codecompanion_auto_tool_mode = true
-- 3. **Pin Important Buffers**: Keep context with #buffer{pin}
-- 4. **Set Clear Completion Criteria**: Define success markers like [TASK COMPLETE]
-- 5. **Use Proper Models**: Claude 3.5 Sonnet, GPT-4o, Gemini 2.0 Flash work best
--
-- ## Available Tools
--
-- - @editor / @insert_edit_into_file: Modify code in files
-- - @cmd_runner: Execute shell commands and see output
-- - @full_stack_dev: Advanced development variable with project context
--
-- ## References
--
-- For more details, see the official agentic workflows discussion:
-- https://github.com/olimorris/codecompanion.nvim/discussions/877
--
-- ═══════════════════════════════════════════════════════════════════════════

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
      adapters = require "eric.plugins.codecompanion.adapters",

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
            slash_commands = require "eric.plugins.codecompanion.slash_commands",

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

      -- Prompt library (custom prompts)
      prompt_library = require "eric.plugins.codecompanion.prompts",

      -- Options
      opts = {
        log_level = "INFO", -- TRACE|DEBUG|INFO|WARN|ERROR
        send_code = true,
        use_default_actions = true,
        use_default_prompt_library = true,
      },
    }

    -- Initialize autosave for CodeCompanion buffers
    -- Saves chat history to ~/.local/share/nvim/codecompanion/
    require("eric.plugins.codecompanion.autosave").setup {
      enabled = true,
      triggers = {
        "BufLeave", -- When leaving buffer
        "FocusLost", -- When Neovim loses focus
      },
      save_dir = "~/.local/share/nvim/codecompanion/",
      notify_on_save = false, -- Set to true to see save notifications
    }
  end,
}
