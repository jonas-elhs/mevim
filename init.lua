if vim.env.PROF then
  require("snacks.profiler").startup({
    startup = {
      event = "UIEnter",
    },
  })
end

-- vim.opt.rtp:append("/home/jonas/colorful-winsep.nvim")

vim.opt.rtp:append("~/.config/nvim-colors")
require("jonas")
