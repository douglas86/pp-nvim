-- Order of plugins
-- Most important at the top: language server protocals and plugin managers
-- Plugins that change neovim functionality
-- Plugins used for testing and debugging
-- Plugins that give neovim extra function but is loaded for all filetypes
-- Third party plugin that are loaded based on filetypes: this will be in alphabitical order

local plugins = {
  {
    -- Description: this plugin is used to populate the popup window
    --   for faster code executions
    "neovim/nvim-lspconfig",
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end,
  },
  {
    -- Description: this is used as a light weight plugin manager
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "black",
        "debugpy",
        "mypy",
        "ruff",
        "pyright",
      }
    }
  },
  {
    -- Description: use neovim as a language server to inject LSP diagnostics, code actions, and more via lua
    --  This repo has been archived by the owner
    "jose-elias-alvarez/null-ls.nvim",
    ft = { "python" },
    opts = function()
      return require "custom.configs.null-ls"
    end,
  },
  {
    -- Description: This help with autosaving, it will autosave
    --   on InsertLeave and TextChanged
    "0x00-ketsu/autosave.nvim",
    lazy = false,
    config = function()
      local autosave = require("autosave")
      autosave.setup({
        enable = true,
        prompt_style = 'stdout',
        prompt_message = function()
          return 'Autosave: saved at ' .. vim.fn.strftime('%H:%M:%S')
        end,
        events = { 'InsertLeave', 'TextChanged' },
        conditions = {
          exists = true,
          modifiable = true,
          filename_is_not = {},
          filetype_is_not = {},
        },
        write_all_buffers = false,
        debounce_delay = 135
      })
    end
  },
  {
    -- Description: This is used to store session based on the directory that I am in
    --   in will save session on save
    "shatur/neovim-session-manager",
    lazy = false,
    config = function()
      local Path = require("plenary.path")
      local config = require("session_manager.config")
      require("session_manager").setup({
        session_dir = Path:new(vim.fn.stdpath('data'), 'session'),
        -- session_filename_to_dir = session_filename_to_dir,
        autoload_mode = config.AutoloadMode.CurrentDir,
        autosave_last_session = true,
        autosave_ignore_not_normal = true,
        autosave_ignore_dirs = {},
        autosave_ignore_filetypes = {
          'gitcommit',
          'gitrebase',
          'snippets',
        },
        autosave_ignore_buftypes = {},
        autosave_only_in_session = false,
        max_path_length = 80,
      })
    end
  },
  {
    -- Description: Keeps the cursor centered on the screen
    --   in a window pane
    "arnamak/stay-centered.nvim",
    lazy = false,
    config = function()
      require("stay-centered").setup()
    end,
  },
  {
    -- Description: I use this plugin to close all hidden buffers
    --   using and auto command
    "kazhala/close-buffers.nvim",
    lazy = false,
  },
  {
    -- Description: This plugin will handle all git commands
    --   using ctrl+g it opens up a new terminal for git
    "kdheepak/lazygit.nvim",
    lazy = false,
    config = function()
      require("core.utils").load_mappings("lazygit")
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
    }
  },
  {
    -- Description: This plugin is used to autoformat code on save
    --   using the event defined below
    "stevearc/conform.nvim",
    lazy = false,
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>f",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = "",
        desc = "Format buffer",
      },
    },
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          lua = { "stylua" },
          python = { "isort", "black" },
          javascipt = { "prettier" },
          css = { "prettier" },
          htmldjango = { "djlint" },
        },
        format_on_save = {
          timeout_ms = 500,
          lsp_fallback = true,
        }
      })
    end,
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end
  },
  {
    -- Description: this is used for debugging and testing code
    --   using breakpoints and other functionality
    "mfussenegger/nvim-dap",
    config = function()
      require("core.utils").load_mappings("dap")
    end
  },
  {
    -- Description: Give a user interface for running debugger window
    --  this is used in conjunction with nvim-dap
    "rcarriga/nvim-dap-ui",
    dependencies = "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup()
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end
  },
  {
    -- Description: this is an adaptor for python with nvim-dap plugin
    --   giving me support for the python language protocals
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = {
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
    },
    config = function()
      local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
      require("dap-python").setup(path)
      require("core.utils").load_mappings("dap_python")
    end,
  },
  {
    -- Description: This will open a Markdown or Readme file in a new browser tab
    --   I have set an auto command to open automatically
    --   If I close the markdown or readme file in question it will auto close browser tab
    "iamcco/markdown-preview.nvim",
    ft = "markdown",
    cmd = { "MarkdownPreview", "MarkdownPreviewStop" },
    -- Details: I had todo npm install in the directory where this plugin was installed
    build = "cd app && npm install",
    init = function()
      vim.g.mkdp_theme = 'light'
      vim.g.mkdp_auto_start = 1
    end,
    config = function()
      vim.keymap.set("n", "<Leader>mp", "<Plug>MarkdownPreview", { desc = "Markdown Preview" })
    end
  },
}

return plugins
