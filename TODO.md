# Neovim Plugin TODO List

## Currently Installed Plugins ✓

- [x] lazy.nvim - Modern plugin manager
- [x] mason.nvim - LSP/DAP/linter installer
- [x] nvim-lspconfig - LSP configurations
- [x] nvim-treesitter - Better syntax highlighting
- [x] blink.cmp - Fast completion engine
- [x] minuet-ai.nvim - AI completion
- [x] telescope.nvim - Fuzzy finder
- [x] neo-tree.nvim - File explorer
- [x] which-key.nvim - Keybinding helper
- [x] conform.nvim - Formatting
- [x] nvim-lint - Linting
- [x] nvim-dap + nvim-dap-ui - Debugging
- [x] gitsigns.nvim - Git integration
- [x] barbar.nvim - Buffer/tab management
- [x] indent-blankline.nvim - Indent guides
- [x] nvim-autopairs - Auto-close brackets
- [x] todo-comments.nvim - Highlight TODOs
- [x] vim-floaterm - Floating terminal
- [x] transparent.nvim - Transparent background
- [x] monokai-pro.nvim - Color scheme
- [x] mini.nvim - Collection of independent modules
- [x] guess-indent.nvim - Auto-detect indentation
- [x] LuaSnip - Snippet engine

## Plugins to Consider Adding

### Status Line & UI Bars

- [ ] **lualine.nvim** - Beautiful, fast statusline (one of the most popular plugins)
  - Repo: `nvim-lualine/lualine.nvim`
  - Why: Professional status line with tons of customization options

- [ ] **nvim-navic.nvim** - Shows code context in winbar/statusline
  - Repo: `SmiteshP/nvim-navic`
  - Why: See current function/class location in status bar

### Enhanced Editing

- [ ] **Comment.nvim** - Smart commenting with treesitter support
  - Repo: `numToStr/Comment.nvim`
  - Why: Better than default commenting, context-aware

- [ ] **nvim-surround** - Add/change/delete surrounding chars (quotes, brackets, etc.)
  - Repo: `kylechui/nvim-surround`
  - Why: Essential for quick editing, change "hello" to 'hello' or (hello)

- [ ] **flash.nvim** - Quick navigation/jumping within files
  - Repo: `folke/flash.nvim`
  - Why: Navigate to any visible location with 2-3 keystrokes

- [ ] **hop.nvim** - Alternative quick navigation
  - Repo: `phaazon/hop.nvim`
  - Why: Similar to flash.nvim, choose based on preference

### Git Integration

- [ ] **fugitive.vim** - Full Git wrapper (by Tim Pope, legendary)
  - Repo: `tpope/vim-fugitive`
  - Why: The gold standard for Git integration in Vim/Neovim

- [ ] **diffview.nvim** - Better diff and merge tool interface
  - Repo: `sindrets/diffview.nvim`
  - Why: Beautiful diff views, file history, merge conflict resolution

- [ ] **neogit** - Magit clone for Neovim
  - Repo: `NeogitOrg/neogit`
  - Why: Full-featured Git UI inside Neovim

### Diagnostics & Trouble

- [ ] **trouble.nvim** - Beautiful diagnostics list, quickfix, and location list
  - Repo: `folke/trouble.nvim`
  - Why: Better way to view and navigate diagnostics/errors

### Session Management

- [ ] **persistence.nvim** - Simple session management
  - Repo: `folke/persistence.nvim`
  - Why: Auto-save and restore sessions

- [ ] **auto-session** - Alternative session manager
  - Repo: `rmagatti/auto-session`
  - Why: More features than persistence.nvim

### File Management

- [ ] **oil.nvim** - Edit filesystem like a buffer
  - Repo: `stevearc/oil.nvim`
  - Why: Game-changer for file operations, edit dirs like text files

### Markdown Support

- [ ] **markdown-preview.nvim** - Live preview in browser
  - Repo: `iamcco/markdown-preview.nvim`
  - Why: Essential for markdown writing

- [ ] **render-markdown.nvim** - Better markdown rendering in editor
  - Repo: `MeanderingProgrammer/render-markdown.nvim`
  - Why: Pretty markdown in Neovim itself

- [ ] **markview.nvim** - Hackable Markdown/HTML/LaTeX renderer
  - Repo: `OXY2DEV/markview.nvim`
  - Why: Advanced markdown rendering

### UI Enhancements

- [ ] **noice.nvim** - Replaces UI for messages, cmdline, and popupmenu
  - Repo: `folke/noice.nvim`
  - Why: Beautiful modern UI, but can be heavy

- [ ] **dressing.nvim** - Better UI for vim.ui interfaces
  - Repo: `stevearc/dressing.nvim`
  - Why: Makes input/select prompts use telescope or other nice UIs

### Code Intelligence

- [ ] **lspsaga.nvim** - Enhanced LSP UI
  - Repo: `nvimdev/lspsaga.nvim`
  - Why: Better hover, rename, code actions, outline

### Trending 2025 Plugins

- [ ] **tiny-glimmer.nvim** - Smooth animations for yank, paste, undo, etc.
  - Repo: `rachartier/tiny-glimmer.nvim`
  - Why: Eye candy, helps visualize what changed

- [ ] **codecompanion.nvim** - AI chat with multiple providers
  - Repo: `olimorris/codecompanion.nvim`
  - Why: Copilot Chat-like experience with multiple AI backends

### Utility & Productivity

- [ ] **nvim-colorizer.lua** - Highlight color codes
  - Repo: `NvChad/nvim-colorizer.lua`
  - Why: See colors inline (#ff0000 shows red)

- [ ] **toggleterm.nvim** - Advanced terminal management
  - Repo: `akinsho/toggleterm.nvim`
  - Why: Alternative to floaterm with more features

- [ ] **harpoon** - Quick file navigation marks
  - Repo: `ThePrimeagen/harpoon`
  - Why: Quickly jump between frequently used files

- [ ] **undotree** - Visualize undo history
  - Repo: `mbbill/undotree`
  - Why: See and navigate undo tree graphically

- [ ] **nvim-spectre** - Find and replace across project
  - Repo: `nvim-pack/nvim-spectre`
  - Why: Project-wide search and replace with preview

### Debugging Enhancements

- [ ] **nvim-dap-virtual-text** - Show variable values as virtual text
  - Repo: `theHamsta/nvim-dap-virtual-text`
  - Why: See variable values inline while debugging

### Testing

- [ ] **neotest** - Test runner framework
  - Repo: `nvim-neotest/neotest`
  - Why: Run tests from Neovim with nice UI

### Language-Specific

- [ ] **go.nvim** - Enhanced Go support (if you use Go)
  - Repo: `ray-x/go.nvim`
  - Why: Go-specific features beyond LSP

- [ ] **rustaceanvim** - Better Rust tooling (if you use Rust)
  - Repo: `mrcjkb/rustaceanvim`
  - Why: Replaces rust-tools.nvim

### Motion & Text Objects

- [ ] **nvim-treesitter-textobjects** - Treesitter-based text objects
  - Repo: Part of nvim-treesitter
  - Why: Select functions, classes, parameters as text objects

- [ ] **mini.ai** - Better text objects (might already have via mini.nvim)
  - Already installed via mini.nvim
  - Why: Enhanced a/i text objects

## User-Requested Plugins Status

### ✅ Already Installed/Configured
- [x] **avante.nvim** - Configured but COMMENTED OUT in `lua/eric/plugins.lua:2`
  - Already has config file with Claude/Ollama/Moonshot providers
  - Includes render-markdown.nvim dependency
  - **Action:** Just uncomment to enable!

- [x] **Ruby LSP** - `ruby_lsp` in `lua/eric/plugins/lsp.lua:137`
- [x] **Python LSP** - `pyright` in `lua/eric/plugins/lsp.lua:136`
- [x] **Rust LSP** - `rust_analyzer` in `lua/eric/plugins/lsp.lua:138`

### ❌ Not Installed - Ready to Add

- [ ] **telescope-file-browser** - Telescope extension for file browsing
  - Repo: `nvim-telescope/telescope-file-browser.nvim`
  - Why: Browse files/folders in telescope (complement to neo-tree)

- [ ] **barbecue.nvim** - VSCode-like winbar breadcrumbs
  - Repo: `utilyre/barbecue.nvim`
  - Why: Shows file path and LSP context in winbar

- [ ] **vim-illuminate** - Highlight word under cursor
  - Repo: `RRethy/vim-illuminate`
  - Why: Auto-highlight other occurrences of current word

- [ ] **claude-code.nvim** - Claude Code integration
  - Repo: `greggh/claude-code.nvim`
  - Why: Integrate with Claude Code features in Neovim

- [ ] **multicursors.nvim** - Multiple cursors support
  - Repo: `smoka7/multicursors.nvim`
  - Why: VSCode-like multiple cursor editing

- [ ] **TypeScript LSP** - `ts_ls` (or `tsserver`)
  - Need to add to servers table in lsp.lua

- [ ] **Elixir LSP** - `elixir_ls` or `lexical`
  - Need to add to servers table in lsp.lua

### ⚠️ Alternatives Already Installed (Skip)

- [x] **nvim-tree.lua** - SKIP (you have neo-tree.nvim which is better)
- [x] **nvim-cmp** - SKIP (you have blink.cmp which is newer/faster)

## Configuration Issues Found

### 🐛 Bugs to Fix

1. **Duplicate gitsigns** in `lua/eric/plugins.lua:10-11`
   ```lua
   require "eric.plugins.gitsigns",
   require "eric.plugins.gitsigns",  -- DUPLICATE LINE 11
   ```

### ⚡ Performance Optimizations

1. **Uncomment updatetime/timeoutlen** in `lua/eric/settings.lua:20-21`
   ```lua
   vim.o.updatetime = 250    -- Currently commented, faster CursorHold
   vim.o.timeoutlen = 300    -- Currently commented, faster which-key
   ```

2. **Add formatters to mason** in `lua/eric/plugins/lsp.lua:142`
   - Currently only has `stylua`
   - Should add: `prettier`, `black`, `rubocop`, `rustfmt`, etc.

3. **Enable inlay hints by default** (optional)
   - Currently manual toggle via `<leader>th`
   - Could auto-enable in lsp.lua

### 🎨 Quality of Life

1. **Consider blink.cmp preset change** in `lua/eric/plugins/blink.lua:60`
   - Currently: `preset = "enter"`
   - Alternative: `preset = "super-tab"` for tab completion

2. **Enable more LSP servers** in `lua/eric/plugins/lsp.lua:110-120`
   - Many useful ones commented: `gopls`, `clangd`, etc.

## Currently Commented Out

- [ ] **avante.nvim** - Chat with your code (Cursor AI-like)
  - Status: Commented out in plugins.lua line 2
  - Decision: Enable or remove?

## Notes

- Most popular must-haves: lualine, Comment.nvim, nvim-surround, trouble.nvim
- Consider your workflow before adding too many plugins
- Test plugins individually to avoid conflicts
- Some plugins overlap (choose one): flash vs hop, persistence vs auto-session
- mini.nvim already includes many small utilities, check before adding duplicates

## Installation Order Suggestion

1. Start with core QoL improvements: lualine, Comment.nvim, nvim-surround
2. Add navigation: flash.nvim or hop.nvim
3. Add diagnostics: trouble.nvim
4. Add Git: fugitive + diffview
5. Add other tools based on your specific needs
