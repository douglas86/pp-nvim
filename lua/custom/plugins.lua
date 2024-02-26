local plugins = {
  {
    "arnamak/stay-centered.nvim",
    lazy = false,
    config = function ()
      require("stay-centered").setup()
    end,
  },
  {
    "iamcco/markdown-preview.nvim",
    ft = "markdown",
    cmd = { "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && npm install",
    init = function ()
      vim.g.mkdp_theme = 'light'
      vim.g.mkdp_auto_start = 1
    end,
    config = function ()
      vim.keymap.set("n", "<Leader>mp", "<Plug>MarkdownPreview", { desc = "Markdown Preview" })
    end
  },
  {
    "shatur/neovim-session-manager",
    lazy = false,
    config = function ()
      local Path = require("plenary.path")
      local config = require("session_manager.config")
      require("session_manager").setup({
        session_dir = Path:new(vim.fn.stdpath('data'), 'session'),
        session_filename_to_dir = session_filename_to_dir,
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
    "kdheepak/lazygit.nvim",
    lazy = false,
    config = function ()
      require("core.utils").load_mappings("lazygit")
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
    }
  },
  -- autosave
  {
    "0x00-ketsu/autosave.nvim",
    lazy = false,
    config = function ()
      local autosave = require("autosave")
      autosave.setup({
        enable = true,
        prompt_style = 'stdout',
        prompt_message = function ()
          return 'Autosave: saved at ' .. vim.fn.strftime('%H:%M:%S')
        end,
        events = {'InsertLeave', 'TextChanged'},
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
    "rcarriga/nvim-dap-ui",
    dependencies = "mfussenegger/nvim-dap",
    config = function ()
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup()
      dap.listeners.after.event_initialized["dapui_config"] = function ()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function ()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function ()
        dapui.close()
      end
    end
  },
  {
    "mfussenegger/nvim-dap",
    config = function (_, opts)
      require("core.utils") .load_mappings("dap")
    end
  },
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = {
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
    },
    config = function(_, opts)
      local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
      require("dap-python").setup(path)
      require("core.utils").load_mappings("dap_python")
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    ft = {"python"},
    opts = function()
      return require "custom.configs.null-ls"
    end,
  },
  {
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
    "neovim/nvim-lspconfig",
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end,
  }
}

return plugins
