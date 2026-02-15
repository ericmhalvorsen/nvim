return { -- Fuzzy Finder (files, lsp, etc)
  "nvim-telescope/telescope.nvim",
  event = "VimEnter",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { -- If encountering errors, see telescope-fzf-native README for installation instructions
      "nvim-telescope/telescope-fzf-native.nvim",

      -- `build` is used to run some command when the plugin is installed/updated.
      -- This is only run then, not every time Neovim starts up.
      build = "make",

      -- `cond` is a condition used to determine whether this plugin should be
      -- installed and loaded.
      cond = function()
        return vim.fn.executable "make" == 1
      end,
    },
    { "nvim-telescope/telescope-ui-select.nvim" },
    { "nvim-telescope/telescope-file-browser.nvim" },

    -- Useful for getting pretty icons, but requires a Nerd Font.
    { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
  },
  config = function()
    -- Telescope is a fuzzy finder that comes with a lot of different things that
    -- it can fuzzy find! It's more than just a "file finder", it can search
    -- many different aspects of Neovim, your workspace, LSP, and more!
    --
    -- The easiest way to use Telescope, is to start by doing something like:
    --  :Telescope help_tags
    --
    -- After running this command, a window will open up and you're able to
    -- type in the prompt window. You'll see a list of `help_tags` options and
    -- a corresponding preview of the help.
    --
    -- Two important keymaps to use while in Telescope are:
    --  - Insert mode: <c-/>
    --  - Normal mode: ?
    --
    -- This opens a window that shows you all of the keymaps for the current
    -- Telescope picker. This is really useful to discover what Telescope can
    -- do as well as how to actually do it!

    -- [[ Configure Telescope ]]
    -- See `:help telescope` and `:help telescope.setup()`

    local ts_select_dir_for_grep = function()
      local action_state = require "telescope.actions.state"
      local fb = require("telescope").extensions.file_browser
      local live_grep = require("telescope.builtin").live_grep
      local current_line = action_state.get_current_line()

      fb.file_browser {
        files = false,
        depth = false,
        attach_mappings = function(prompt_bufnr)
          require("telescope.actions").select_default:replace(function()
            local entry_path = action_state.get_selected_entry().Path
            local dir = entry_path:is_dir() and entry_path or entry_path:parent()
            local relative = dir:make_relative(vim.fn.getcwd())
            local absolute = dir:absolute()

            live_grep {
              results_title = relative .. "/",
              cwd = absolute,
              default_text = current_line,
            }
          end)

          return true
        end,
      }
    end

    require("telescope").setup {
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_dropdown(),
        },
      },
      defaults = {
        path_display = { "filename_first" },
        mappings = {
          i = {
            ["<C-f>"] = require("telescope.actions").to_fuzzy_refine,
            ["<C-d>"] = ts_select_dir_for_grep,
            ["<C-s>"] = require("telescope.actions").select_vertical,
            ["<C-k>"] = require("telescope.actions").select_horizontal,
          },
          n = {
            ["<C-f>"] = require("telescope.actions").to_fuzzy_refine,
            ["<C-d>"] = ts_select_dir_for_grep,
          },
        },
      },
    }

    pcall(require("telescope").load_extension, "fzf")
    pcall(require("telescope").load_extension, "ui-select")
    pcall(require("telescope").load_extension, "keymaps_nvim")
  end,
}
