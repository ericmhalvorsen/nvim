return {
  "comfysage/keymaps.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("keymaps").setup()
  end,
}
