-- Leader Key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("vim._core.ui2").enable({
  enable = true,
  msg = {
    targets = "msg",
  },
})

require("jonas.core.lsp")
require("jonas.core.theme")
require("jonas.core.options")
require("jonas.core.tabline")
require("jonas.core.mappings")
require("jonas.core.statusline")
require("jonas.core.autocommands")
