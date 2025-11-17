-- COLOUR

--return {
--  "folke/tokyonight.nvim",
--  lazy = false,
--  priority = 1000,
--  opts = {},
--  config = function()
--    local color = "tokyonight-storm"
--    vim.cmd.colorscheme(color)
--  end,
--}
--
--return {
--  "loctvl842/monokai-pro.nvim",
--  config = function()
--    require("monokai-pro").setup()
--  end,
--}
-- return { "catppuccin/nvim", name = "catppuccin", priority = 1000 }
return {
  "sainnhe/sonokai",
  config = function()
    vim.g.sonokai_enable_italic = true
    vim.g.sonokai_style = "andromeda"
    vim.cmd.colorscheme "sonokai"
  end,
}
