require("neogit").setup({
  disable_hint = true,
  graph_style = "kitty",
  kind = "floating",
  signs = {
    -- { CLOSED, OPENED }
    hunk = { "", "" },
    item = { vim.opt.fillchars:get().foldclose, vim.opt.fillchars:get().foldopen },
    section = { vim.opt.fillchars:get().foldclose, vim.opt.fillchars:get().foldopen },
  },
})

vim.keymap.set("n", "<leader>g", "<CMD>Neogit<CR>", { desc = "Open Neogit" })
