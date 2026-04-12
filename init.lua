if vim.env.PROF then
  require("snacks.profiler").startup({
    startup = {
      event = "UIEnter",
    },
  })
end

vim.opt.rtp:append("~/.config/nvim-colors")

vim.loader.enable()

_G.nix = require(vim.g.nix_info_plugin_name)
vim.g.mapleader = " "
vim.g.maplocalleader = " "
