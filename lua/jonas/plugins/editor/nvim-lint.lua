require("lint").linters_by_ft = {
  lua = { "selene" },
}

vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave", "TextChanged" }, {
  group = vim.api.nvim_create_augroup("JonasLint", {}),
  callback = function()
    require("lint").try_lint()
  end,
})
