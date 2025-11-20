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

vim.api.nvim_create_user_command("FormatToggle", function()
  vim.g.disable_autoformat = not vim.g.disable_autoformat
end, { desc = "Toggle autoformat" })
vim.api.nvim_create_user_command("FormatEnable", function()
  vim.g.disable_autoformat = false
end, { desc = "Enable autoformat" })
vim.api.nvim_create_user_command("FormatDisable", function()
  vim.g.disable_autoformat = true
end, { desc = "Disable autoformat" })

vim.keymap.set("n", "<leader>f", function()
  require("conform").format()
end, { desc = "Format buffer" })
vim.keymap.set("n", "<leader>F", "<CMD>FormatToggle<CR>", { desc = "Toggle autoformat" })
