require("neogit").setup({
  disable_hint = true,
  graph_style = "kitty",
  kind = "floating",
  floating = {
    width = 0.9,
    height = 0.9,
    style = "minimal",
    border = "rounded",
  },
  signs = {
    -- { CLOSED, OPENED }
    hunk = { "", "" },
    item = { vim.opt.fillchars:get().foldclose, vim.opt.fillchars:get().foldopen },
    section = { vim.opt.fillchars:get().foldclose, vim.opt.fillchars:get().foldopen },
  },
  commit_editor = {
    kind = "floating",
  },
})

vim.keymap.set("n", "<leader>g", "<CMD>Neogit<CR>", { desc = "Open Neogit" })
