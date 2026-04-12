-- nvim-dap
local dap = require("dap")

-- C, C++, Rust
dap.adapters.codelldb = {
  type = "executable",
  command = nix.info.codelldb.executable,
}

-- Python
dap.adapters.python = function(callback, config)
  if config.request == "attach" then
    local port = (config.connect or config).port
    local host = (config.connect or config).host or "127.0.0.1"

    callback({
      type = "server",
      port = assert(port, "`connect.port` is required for a python `attach` configuration"),
      host = host,
    })
  else
    callback({
      type = "executable",
      command = "debugpy-adapter",
    })
  end
end

dap.configurations.python = {
  {
    type = "python",
    request = "launch",
    name = "Launch file",

    program = "${file}",
    pythonPath = function()
      local cwd = vim.fn.getcwd()
      if vim.uv.fs_stat(cwd .. "/venv/bin/python") then
        return cwd .. "/venv/bin/python"
      elseif vim.uv.fs_stat(cwd .. "/.venv/bin/python") then
        return cwd .. "/.venv/bin/python"
      else
        return "python"
      end
    end,
  },
  {
    type = "python",
    request = "launch",
    name = "Launch file with args",

    args = function()
      local input = vim.fn.input("Program Arguments")
      return vim.split(input, "%s+", { trimempty = true })
    end,
    program = "${file}",
    pythonPath = function()
      local cwd = vim.fn.getcwd()
      if vim.uv.fs_stat(cwd .. "/venv/bin/python") then
        return cwd .. "/venv/bin/python"
      elseif vim.uv.fs_stat(cwd .. "/.venv/bin/python") then
        return cwd .. "/.venv/bin/python"
      else
        return "python"
      end
    end,
  },
}

-- Signs
for _, sign in pairs({
  "DapLogPoint",
  "DapBreakpoint",
  "DapBreakpointRejected",
  "DapBreakpointCondition",
}) do
  vim.fn.sign_define(sign, { text = "●", texthl = sign })
end
vim.fn.sign_define("DapStopped", { text = "", linehl = "DapStoppedLine" })

-- Mappings
local map = vim.keymap.set
map("n", "<Left>", function()
  return require("dap").session() and require("dap").step_out() or "<Left>"
end, { expr = true })
map("n", "<Down>", function()
  return require("dap").session() and require("dap").step_over() or "<Down>"
end, { expr = true })
map("n", "<Up>", function()
  return require("dap").session() and require("dap").run_last() or "<Up>"
end, { expr = true })
map("n", "<Right>", function()
  return require("dap").session() and require("dap").step_into() or "<Right>"
end, { expr = true })

map("n", "<leader>bb", function()
  require("dap").toggle_breakpoint()
end, { desc = "DAP toggle breakpoint" })
map("n", "<leader>bB", function()
  vim.ui.input({ prompt = "Breakpoint Condition" }, function(input)
    require("dap").set_breakpoint(input)
  end)
end, { desc = "DAP set conditional breakpoint" })
map("n", "<leader>bl", function()
  vim.ui.input({ prompt = "Logpoint Message" }, function(input)
    require("dap").set_breakpoint(nil, nil, input)
  end)
end, { desc = "DAP set logpoint" })
map("n", "<leader>bc", function()
  require("dap").continue()
end, { desc = "DAP run/continue" })
map("n", "<leader>bC", function()
  require("dap").run_to_cursor()
end, { desc = "DAP run to cursor" })
map("n", "<leader>bt", function()
  require("dap").terminate()
end, { desc = "DAP terminate" })
map("n", "<leader>bj", function()
  require("dap").down()
end, { desc = "DAP down" })
map("n", "<leader>bk", function()
  require("dap").up()
end, { desc = "DAP up" })
map("n", "<leader>bp", function()
  require("dap").pause()
end, { desc = "DAP pause" })
map("n", "<leader>bg", function()
  require("dap").goto_()
end, { desc = "DAP go to line" })

-- nvim-dap-view
require("dap-view").setup({
  auto_toggle = true,

  winbar = {
    show = true,
    sections = { "scopes", "watches", "breakpoints", "threads", "repl", "console" },
    default_section = "scopes",
    show_keymap_hints = false,

    controls = {
      enabled = true,
      buttons = {
        "play",
        "step_into",
        "step_over",
        "step_out",
        "run_last",
        "terminate",
      },
    },
  },

  windows = {
    size = 0.3,
  },

  icons = {
    play = "",
    pause = "",
    expanded = " ",
    collapsed = " ",
  },

  render = {
    breakpoints = {
      format = function(line, lnum, path)
        return {
          { text = path, hl = "FileName", separator = " " },
          { text = "(Line " .. lnum .. ")", hl = "LineNumber", separator = ":" },
          { text = line, hl = true },
        }
      end,
      align = true,
    },
  },

  virtual_text = {
    enabled = true,
    format = function(variable, _, _)
      return " = " .. variable.value:gsub("%s+", " ")
    end,
  },
})

map("n", "<leader>bu", function()
  require("dap-view").open()
end, { desc = "Open dap view" })

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "dap-view", "dap-view-term", "dap-repl" },
  callback = function(args)
    vim.wo.listchars = "tab:  ,trail:·,extends:…,precedes:…,nbsp:␣"

    map("n", "q", function()
      require("dap").terminate()
      require("dap-view").close()
    end, { buffer = args.buf })
  end,
})
