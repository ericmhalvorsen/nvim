return {
  "FeiyouG/commander.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "voldikss/vim-floaterm",
    "olimorris/codecompanion.nvim",
    "kevinhwang91/nvim-ufo",
  },
  config = function()
    local commander = require "commander"
    commander.setup {
      components = {
        "DESC",
        "KEYS",
        "CAT",
      },
      sort_by = {
        "DESC",
        "KEYS",
        "CAT",
        "CMD",
      },
      separator = "|",
      prompt_title = "Commander",
      auto_replace_desc_with_cmd = true,
      integration = {
        telescope = {
          enable = true,
        },
        lazy = {
          enable = true,
          set_plugin_name_as_cat = true,
        },
      },
    }

    local keymaps = require "eric.keymaps"

    keymaps.register_all_plugin_keymaps()

    commander.add(keymaps.registered_keymaps)
  end,
}
