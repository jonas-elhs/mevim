require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    nix = { "alejandra" },
    rust = { "rustfmt" },
  },
  format_on_save = function(buffer)
    if vim.g.disable_autoformat or vim.b[buffer].disable_autoformat then
      return
    end

    return { timeout_ms = 1000 }
  end,
})

vim.keymap.set("n", "<leader>f", function()
  require("conform").format()
end, { desc = "Format buffer" })

Utils.toggle({
  name = "Auto Format",
  command = "Format",
  toggle_keymap = "<leader>F",

  enable = function()
    vim.g.disable_autoformat = false
  end,
  disable = function()
    vim.g.disable_autoformat = true
  end,
  enabled = function()
    return vim.g.disable_autoformat ~= true
  end,
})
