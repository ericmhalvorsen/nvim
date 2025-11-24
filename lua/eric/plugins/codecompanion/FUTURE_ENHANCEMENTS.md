# Future Enhancements for CodeCompanion

Ideas and features from `stuff_for_claude` that could be added in the future.

## 🎨 UI Enhancements

### 1. Incline.nvim - Floating File Info
**What it is**: Shows floating filename with git diff stats and diagnostics at the top-right of windows.

**Location**: `stuff_for_claude/lua/plugins/ui.lua`

**Features**:
- Git diff indicators (added/changed/removed lines)
- LSP diagnostic counts (errors, warnings, hints)
- File type icons
- Beautiful floating rendering

**To Add**: Extract the incline config and add as separate plugin in `lua/eric/plugins/incline.lua`

---

### 2. Smear Cursor - Smooth Cursor Animation
**What it is**: Makes your cursor movement smooth and animated instead of instant jumps.

**Location**: `stuff_for_claude/lua/plugins/ui.lua`

**Config**:
```lua
{
  "sphamba/smear-cursor.nvim",
  opts = {
    stiffness = 0.6,
    trailing_stiffness = 0.5,
    distance_stop_animating = 0.1,
  },
}
```

**To Add**: Copy to `lua/eric/plugins/smear-cursor.lua`

---

### 3. Snacks Dashboard Enhancements
**What it is**: Enhanced dashboard with fortune/cowsay/lolcat on startup.

**Location**: `stuff_for_claude/lua/plugins/ui.lua`

**Features**:
- Fortune cookie quotes piped through cowsay and lolcat
- Two-pane layout (keys/startup vs recent files/projects)

**To Add**: Update existing snacks config in your plugins

---

## 🤖 AI & LLM Features

### 4. Crush Integration
**What it is**: Terminal-based AI coding agent by Charm (creators of gum, glow, etc.)

**Location**: `stuff_for_claude/lua/plugins/llm.agent.lua`

**GitHub**: https://github.com/charmbracelet/crush

**Setup**:
```lua
{
  "gitsang/crush.nvim",
  opts = {
    width = 60,
    crush_cmd = "crush --yolo",
  },
  keys = {
    { "<leader>C", "<cmd>Crush<cr>", desc = "Toggle Crush" },
  },
}
```

**Requirements**:
- Install crush CLI: `brew install charmbracelet/tap/crush`
- Configure models in `~/.config/crush/config.json`

**Use Cases**:
- Alternative to CodeCompanion for terminal-based AI coding
- Great for pair programming workflows
- Session management across projects

**To Add**: Copy config to `lua/eric/plugins/crush.lua`

---

### 5. ClaudeCode.nvim ✅ **ADDED**
**What it is**: Direct integration with Claude Code (Anthropic's official coding agent)

**Location**: `lua/eric/plugins/claudecode.lua` (already added!)

**Setup**: Already configured with `claude-wrapper` executable

**Usage**:
- Press `<leader>cc` to toggle Claude Code panel
- Uses your `claude-wrapper` from PATH

**Configuration**: Edit `lua/eric/plugins/claudecode.lua` to customize:
```lua
opts = {
  claude_executable = "claude-wrapper",  -- Your wrapper
  -- auto_open = false,  -- Don't auto-open
  -- position = "right", -- Panel position
}
```

---

## 🔧 Git & Development Tools

### 6. AI-Powered Git Commits
**What it is**: Generate commit messages using AI based on git diff.

**Location**: `stuff_for_claude/lua/plugins/commandline/git_commit.lua`

**Features**:
- Uses `aicommit` CLI tool
- Multiple adapter support (OpenAI, Worklink, etc.)
- Runs in terminal split

**Setup**:
```bash
npm install -g aicommit
# or
brew install aicommit
```

**Commands**:
- `:GitAICommit` - Generate commit message from staged changes
- `:GitAICommitList` - List configured adapters

**To Add**:
1. Install `aicommit`
2. Copy `git_commit.lua` to `lua/eric/plugins/git_commit.lua`
3. Call `require("git_commit").setup()` in your config

---

### 7. Quick Git Diff
**What it is**: Open git diff in a terminal split quickly.

**Location**: `stuff_for_claude/lua/plugins/commandline/git_diff.lua`

**Command**: `:GitDiff`

**To Add**: Copy to `lua/eric/plugins/git_diff.lua`

---

## 🎯 More Slash Commands

### 8. Web Search Slash Command
**What it is**: Search the web from CodeCompanion chat using SearXNG.

**Location**: `stuff_for_claude/lua/plugins/codecompanion/slash_commands/web_search.lua`

**Usage**: `/web_search <query>` in CodeCompanion chat

**Requirements**:
- Access to SearXNG instance (public or self-hosted)
- Currently uses: `https://searxng.us.c8g.top/search`

**To Add**:
1. Copy `web_search.lua` to your slash_commands directory
2. Add to slash_commands/init.lua
3. Update URL to your preferred SearXNG instance

**Alternative**: Use the built-in `/fetch` command with Google/DDG URLs

---

### 9. Custom Variables
**What it is**: Custom variables for CodeCompanion prompts.

**Location**: `stuff_for_claude/lua/plugins/codecompanion/variables/edit_rules.lua`

**Example**: `@edit_rules` variable that includes project editing guidelines

**To Add**:
1. Create `lua/eric/plugins/codecompanion/variables/` directory
2. Copy variable files
3. Register in chat strategy config

---

## 📝 Additional Prompts

### 10. More Prompts from stuff_for_claude

**Available**:
- **Translate** - Translate code/text between languages
- **Merge Request** - Generate MR descriptions from changes
- **Ask** - Generic Q&A prompt with context

**Location**: `stuff_for_claude/lua/plugins/codecompanion/prompt_library/`

**To Add**: Copy desired prompts to `lua/eric/plugins/codecompanion/prompts/`

---

## 🔌 Language-Specific Tools

### 11. Go Tools
**What it is**: Enhanced Go development tools.

**Location**: `stuff_for_claude/lua/plugins/gotools/`

**Features**:
- `gobuild.lua` - Enhanced build commands
- `gomod.lua` - Module management
- `gotags.lua` - Tag generation

**To Add**: If you do Go development, copy to `lua/eric/plugins/gotools/`

---

### 12. SQL Database Tools
**What it is**: Enhanced SQL database management.

**Location**: `stuff_for_claude/lua/plugins/lang.sql.lua`

**Features**: Advanced SQL formatting, query execution, etc.

**To Add**: Copy if you work with databases frequently

---

## 🎨 Treesitter Enhancements

### 13. Custom Markdown Highlights
**What it is**: Enhanced syntax highlighting for markdown files.

**Location**: `stuff_for_claude/lua/plugins/treesitter/queries/`

**Files**:
- `markdown/highlights.scm`
- `markdown_inline/highlights.scm`

**To Add**: Copy to your treesitter queries directory

---

## 📊 Completion Enhancements

### 14. LLM Completion
**What it is**: AI-powered code completion using various LLM providers.

**Location**: `stuff_for_claude/lua/plugins/llm.completion.lua`

**Features**:
- Multiple provider support
- Streaming completions
- Custom keybindings

**To Add**: If you want AI completions separate from CodeCompanion

---

## 🚀 Priority Recommendations

Based on the features above, here's what I'd recommend adding first:

### High Priority (Add Soon):
1. **AI Git Commits** - Very practical for daily use
2. **Incline.nvim** - Great UI enhancement, non-intrusive
3. **Smear Cursor** - Nice visual polish

### Medium Priority (Add When Needed):
4. **Crush** - When you want terminal-based AI coding
5. **Web Search slash command** - When you need web context in chats
6. **Custom variables** - When you have project-specific patterns

### Low Priority (Nice to Have):
7. **Additional prompts** - Add as needed
8. **Language-specific tools** - Only if you use those languages
9. **LLM Completion** - You already have solid completion with Blink

---

## 🎯 Installation Template

When you want to add any of these, follow this pattern:

```lua
-- 1. Copy the file(s) to your config
-- Example: cp stuff_for_claude/lua/plugins/ui.lua lua/eric/plugins/incline.lua

-- 2. Extract just the config you want
-- Example: Copy just the incline section from ui.lua

-- 3. Test it works
-- :Lazy reload

-- 4. Commit it
-- git add lua/eric/plugins/incline.lua
-- git commit -m "Add incline.nvim for floating file info"
```

---

**Last Updated**: 2025-01-22
