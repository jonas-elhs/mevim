require("treesj").setup({
  max_join_length = 9999,
  use_default_keymaps = false,
})

vim.keymap.set("n", "gs", function()
  require("treesj").toggle()
end, { desc = "Toggle node under cursor" })

vim.keymap.set("n", "gS", function()
  require("treesj").toggle({ split = { recursive = true } })
end, { desc = "Toggle node under cursor recursively" })
