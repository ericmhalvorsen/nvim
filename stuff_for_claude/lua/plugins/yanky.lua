return {
  "gbprod/yanky.nvim",
  opts = {},
  dependencies = { "folke/snacks.nvim" },
  keys = {
    { "<leader>SW", "<cmd>wshada<cr>", desc = "Write Shada" },
    { "<leader>SR", "<cmd>rshada<cr>", desc = "Read Shada" },
  },
  config = function(_, opts)
    require("yanky").setup(opts)

    vim.api.nvim_create_autocmd("TextYankPost", {
      callback = function()
        vim.cmd("wshada")
      end,
    })

    vim.api.nvim_create_autocmd("CursorHold", {
      callback = function()
        vim.cmd("rshada")
      end,
    })
    vim.opt.updatetime = 200
  end,
}
