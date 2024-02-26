local M = {}

M.dap = {
  plugin = true,
  n = {
    ["<leader>db"] = {"<cmd> DapToggleBreakpoint <CR>", "toggle breakpoint"},
  }
}

M.dap_python = {
  plugin = true,
  n = {
    ["<leader>dpr"] = {
      function ()
        require("dap-python").test_method()
      end,
      "run test method"
    }
  }
}

M.lazygit = {
  plugin = true,
  n = {
    ["<c-g>"] = {"<cmd> LazyGit <CR>", "toggle lazygit"}
  }
}

return M
