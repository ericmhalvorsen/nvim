local function get_first_ip(interface)
  local handle = io.popen("ip -4 addr show " .. interface .. " | grep inet | awk '{print $2}' | cut -d/ -f1")
  if not handle then
    return nil
  end
  local result = handle:read("*a")
  handle:close()
  return result and result:match("%d+%.%d+%.%d+%.%d+")
end

local default_browser = require("vars.environment").default_browser
local net_interface = require("vars.environment").net_interface
local main_ip = get_first_ip(net_interface)
local HOME = os.getenv("HOME")

return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-mini/mini.icons",
    },
    ft = { "markdown", "codecompanion", "Avante" },
    opts = {
      file_types = { "markdown", "codecompanion", "Avante" },
      enabled = true,
      render_modes = { "n", "v", "V", "\22", "i", "c", "t" },
      completions = {
        lsp = {
          enabled = true,
        },
      },
      anti_conceal = {
        enabled = true,
        ignore = {
          code_language = true,
          code_background = true,
          sign = true,
        },
        above = 0,
        below = 0,
      },
      heading = {
        enabled = true,
        render_modes = false,
        sign = true,
        icons = { "# ", "## ", "### ", "#### ", "##### ", "###### " },
        position = "overlay",
        signs = { "󰫎 " },
        border = false,
      },
      bullet = {
        enabled = true,
        render_modes = false,
        icons = { "", "" },
        ordered_icons = function(ctx)
          local value = vim.trim(ctx.value)
          local index = tonumber(value:sub(1, #value - 1))
          return string.format("%d.", index > 1 and index or ctx.index)
        end,
        left_pad = 0,
        right_pad = 0,
        highlight = "RenderMarkdownBullet",
        scope_highlight = {},
      },
      code = {
        enabled = true,
        render_modes = false,
        sign = true,
        style = "full",
        position = "right",
        language_pad = 0,
        language_name = true,
        disable_background = { "diff" },
        width = "block",
        left_margin = 0,
        left_pad = 0,
        right_pad = 0,
        min_width = 0,
        border = "thin",
        above = "▄",
        below = "▀",
        highlight = "RenderMarkdownCode",
        highlight_language = nil,
        inline_pad = 0,
        highlight_inline = "RenderMarkdownCodeInline",
      },
      win_options = {
        conceallevel = {
          default = vim.api.nvim_get_option_value("conceallevel", {}),
          -- rendered = 0,
        },
        concealcursor = {
          default = vim.api.nvim_get_option_value("concealcursor", {}),
          rendered = "",
        },
      },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      table.insert(opts.sources, 1, {
        name = "render-markdown",
        group_index = 1,
        priority = 100,
      })
    end,
  },
  {
    "gitsang/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && npx --yes yarn install",
    keys = {
      {
        "<F8>",
        ft = "markdown",
        "<cmd>MarkdownPreviewToggle<cr>",
        desc = "Markdown Preview",
      },
    },
    config = function()
      vim.cmd([[do FileType]])
      vim.g.mkdp_auto_start = 0
      vim.g.mkdp_auto_close = 1
      vim.g.mkdp_refresh_slow = 0
      vim.g.mkdp_command_for_global = 0
      vim.g.mkdp_open_to_the_world = 1
      vim.g.mkdp_open_ip = main_ip
      vim.g.mkdp_port = "7777"
      vim.g.mkdp_browser = default_browser
      vim.g.mkdp_echo_preview_url = 1
      vim.g.mkdp_browserfunc = ""
      vim.g.mkdp_preview_options = {
        mkit = {},
        katex = {},
        uml = {},
        maid = {},
        disable_sync_scroll = 0,
        sync_scroll_type = "middle",
        hide_yaml_meta = 1,
        sequence_diagrams = {},
        flowchart_diagrams = {},
        content_editable = false,
        disable_filename = 0,
      }
      vim.g.mkdp_markdown_css = ""
      vim.g.mkdp_highlight_css = ""
      vim.g.mkdp_page_title = "「${name}」"
      vim.g.mkdp_filetypes = { "markdown" }
    end,
  },
  {
    "mzlogin/vim-markdown-toc",
    config = function()
      vim.g.vmt_auto_update_on_save = 1
      vim.g.vmt_dont_insert_fence = 0
      vim.g.vmt_fence_text = "markdown-toc"
      vim.g.vmt_fence_closing_text = "/markdown-toc"
      vim.g.vmt_fence_hidden_markdown_style = ""
      vim.g.vmt_cycle_list_item_markers = 0
      vim.g.vmt_list_item_char = "-"
      vim.g.vmt_include_headings_before = 0
      vim.g.vmt_list_indent_text = "  "
      vim.g.vmt_link = 1
      vim.g.vmt_min_level = 1
      vim.g.vmt_max_level = 6
    end,
  },
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        markdown = {},
      },
      linters = {
        ["markdownlint-cli2"] = {
          args = { "--config", HOME .. "/.markdownlint-cli2.yaml", "--" },
        },
      },
    },
  },
  {
    "gitsang/markdown-title-numbering.nvim",
    opts = {},
  },
  {
    "gitsang/markdown-front-matter.nvim",
    enabled = true,
    opts = {
      llm = {
        provider = "worklink",
        providers = {
          ["worklink"] = {
            base_url = "http://openai-proxy.ops.yl.c8g.top:8888/llmproxy/v1/chat/completions",
            api_key = require("vars.secret").worklink_llm,
            model = "gpt-4o",
          },
        },
      },
      always_update_description = true, -- Set to true to always update description regardless of existing content
    },
  },
}
