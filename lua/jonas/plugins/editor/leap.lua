require("leap").setup({
  safe_labels = "",
  max_phase_one_targets = 1,
})

vim.api.nvim_set_hl(0, "LeapLabel", { fg = "#ff0000", bg = "NONE", bold = true })

vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap)", { desc = "Leap" })
