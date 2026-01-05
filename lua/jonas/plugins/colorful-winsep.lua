require("colorful-winsep").setup({
  border = "rounded",
  animate = {
    enabled = "progressive",
    progressive = {
      vertical_delay = 10,
      horizontal_delay = 1,
    },
  },
  indicator_for_2wins = {
    symbols = {
      start_left = "╭",
      end_left = "╰",
      start_down = "╰",
      end_down = "╯",
      start_up = "╭",
      end_up = "╮",
      start_right = "╮",
      end_right = "╯",
    },
  },
})
vim.api.nvim_set_hl(0, "ColorfulWinSep", { link = "JonasCurrentModeReverse" })
