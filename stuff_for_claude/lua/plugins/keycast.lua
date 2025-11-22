return {
  {
    "tamton-aquib/keys.nvim",
    enabled = true,
    opts = {
      enable_on_startup = false,
      win_opts = {
        width = 25,
      },
    },
  },
  {
    "hasundue/vim-keycasty",
    enabled = true,
    dependencies = {
      -- https://docs.deno.com/runtime/getting_started/installation/
      "vim-denops/denops.vim",
    },
  },
}
