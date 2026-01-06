require("conform").setup({
  formatters_by_ft = {
    sh = { "shfmt" },
    lua = { "stylua" },
    nix = { "alejandra" },
    qml = { "qmlformat" },
    rust = { "rustfmt" },
    python = { "ruff_organize_imports", "ruff_format" },

    c = { "clang-format" },
    cpp = { "clang-format" },

    css = { "prettierd" },
    html = { "prettierd" },
    scss = { "prettierd" },
    yaml = { "prettierd" },
    json = { "prettierd" },
    svelte = { "prettierd" },
    javascript = { "prettierd" },
    typescript = { "prettierd" },
  },

  format_on_save = function()
    return not vim.g.disable_autoformat and { timeout_ms = 1000 }
  end,
})

vim.keymap.set("n", "<leader>f", function()
  require("conform").format()
end, { desc = "Format buffer" })

Utils.toggle({
  name = "Auto Format",
  command = "Format",
  keymap = "<leader>tf",

  toggle = function()
    vim.g.disable_autoformat = not vim.g.disable_autoformat
  end,
  enabled = function()
    return not vim.g.disable_autoformat
  end,
})
