return {
  "kristijanhusak/vim-dadbod-ui",
  dependencies = {
    { "tpope/vim-dadbod", lazy = true },
    { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
  },
  cmd = {
    "DBUI",
    "DBUIToggle",
    "DBUIAddConnection",
    "DBUIFindBuffer",
  },
  keys = {
    { "<leader>D", "<cmd>DBUIToggle<CR>", desc = "Toggle DBUI" },
  },
  init = function()
    -- Configuration for vim-dadbod-ui
    local data_path = vim.fn.stdpath "data"

    -- Use nerd fonts for icons
    vim.g.db_ui_use_nerd_fonts = 1

    -- Save location for queries and connections
    vim.g.db_ui_save_location = data_path .. "/dadbod_ui"

    -- Temporary query location
    vim.g.db_ui_tmp_query_location = data_path .. "/dadbod_ui/tmp"

    -- Show database icons in the UI
    vim.g.db_ui_show_database_icon = 1

    -- Use nvim-notify for notifications if available
    vim.g.db_ui_use_nvim_notify = 1

    -- Don't auto-execute queries on save (safer for large queries)
    vim.g.db_ui_execute_on_save = 0

    -- Auto-execute table helpers (SELECT * FROM table LIMIT 200)
    vim.g.db_ui_auto_execute_table_helpers = 1

    -- Optional: Define database connections here
    -- NOTE: It's recommended to use environment variables or a separate
    -- non-committed file for sensitive database credentials
    --
    -- Example configurations:
    -- vim.g.dbs = {
    --   dev = "postgres://user:password@localhost:5432/my_dev_db",
    --   staging = "postgres://user:password@staging-host:5432/my_staging_db",
    --   sqlite_local = "sqlite:///path/to/database.db",
    --   mysql_local = "mysql://user:password@localhost:3306/my_db",
    -- }
    --
    -- Supported database types:
    -- - PostgreSQL: postgres://user:password@host:port/database
    -- - MySQL/MariaDB: mysql://user:password@host:port/database
    -- - SQLite: sqlite:///absolute/path/to/database.db
    -- - SQL Server: sqlserver://user:password@host:port/database
    -- - MongoDB: mongodb://user:password@host:port/database
    -- - Redis: redis://host:port/database
    -- - And many more! See :h dadbod for full list
  end,
}
