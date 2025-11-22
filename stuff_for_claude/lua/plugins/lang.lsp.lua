return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ["*"] = {
          keys = {
            { "<leader>cc", mode = { "n", "v" }, false },
          },
        },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = {
        enabled = false,
      },
      diagnostics = {
        -- for virtual text at end of line
        virtual_text = {
          source = true,
        },
        -- for the floating diagnostics window when press `<leader>cd`
        float = {
          source = true,
        },
      },
    },
  },
  {
    "nvim-lua/plenary.nvim", -- 确保依赖已安装
    config = function()
      -- 定义Markdown代码块跳转功能
      vim.api.nvim_set_keymap(
        "n",
        "%",
        [[<cmd>lua require("markdown_pairs").jump()<CR>]],
        { noremap = true, silent = true }
      )

      -- 创建一个Lua模块以供调用
      _G.markdown_pairs = {}
      function _G.markdown_pairs.jump()
        local line = vim.fn.getline(".")
        if line:match("^```") then
          local searchDirection = "n"
          if line:sub(1, 3) == "```" then
            searchDirection = "b"
          end
          vim.fn.search("^```", searchDirection .. "W")
        else
          print("Not on a Markdown code block delimiter")
        end
      end
    end,
  },
}
