require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    nix = { "alejandra" },
    rust = { "rustfmt" },
  },
  format_on_save = function(buffer)
    if vim.g.disable_autoformat then
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
  keymap = "<leader>tf",

  toggle = function()
    vim.g.disable_autoformat = not vim.g.disable_autoformat
  end,
  enabled = function()
    return not vim.g.disable_autoformat
  end,
})
