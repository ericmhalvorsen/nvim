return {
  "voldikss/vim-floaterm",
  config = function()
    require("eric.keymaps").setup_floaterm_keymaps()
  end,
}
