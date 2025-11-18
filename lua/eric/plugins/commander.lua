return {
  "FeiyouG/commander.nvim",
  dependencies = { "nvim-telescope/telescope.nvim" },
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
    commander.add({ { desc = "Open commander", cmd = commander.show, keys = { "n", "<leader>p" } } }, {})
  end,
}
