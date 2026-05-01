if vim.env.PROFILE then
  require("snacks.profiler").startup({
    startup = {
      event = "UIEnter",
    },
  })
end

vim.opt.rtp:append("~/.config/nvim-colors")
vim.loader.enable()

_G.Nix = require(vim.g.nix_info_plugin_name)
_G.Utils = require("jonas.utils")

vim.g.mapleader = " "
vim.g.maplocalleader = " "
