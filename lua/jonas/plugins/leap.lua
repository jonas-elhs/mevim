require("leap").setup({
  safe_labels = "",
})

vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap-anywhere)")
