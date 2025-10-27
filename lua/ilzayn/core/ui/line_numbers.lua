local utils = require("ilzayn.utils")

vim.api.nvim_create_autocmd(
  { "VimEnter", "ModeChanged" },
  {
    callback = function(event)
      vim.api.nvim_set_hl(
        0,
        "CursorLineNr",
        { link = utils.mode.get_highlight_group(true) }
      )
    end
  }
)
