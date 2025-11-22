return {
  {
    "local/gotools",
    dir = vim.fn.stdpath("config") .. "/lua/plugins/gotools",
    ft = "go",
    config = function()
      require("plugins.gotools.gotags").setup()
      require("plugins.gotools.gomod").setup()
      require("plugins.gotools.gobuild").setup()
    end,
  },
  {
    "local/commandline",
    dir = vim.fn.stdpath("config") .. "/lua/plugins/commandline",
    config = function()
      require("plugins.commandline.git_commit").setup()
      require("plugins.commandline.git_diff").setup()
      require("plugins.commandline.format").setup()
      require("plugins.commandline.yaml_format").setup()
    end,
  },
  {
    "will133/vim-dirdiff",
  },
  {
    "gitsang/vim-case-converter",
  },
}
