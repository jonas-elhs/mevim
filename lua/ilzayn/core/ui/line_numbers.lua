vim.api.nvim_create_autocmd(
  { "VimEnter", "ModeChanged" },
  {
    callback = function(event)
      vim.api.nvim_set_hl(
        0,
        "CursorLineNr",
        { link = "IlzaynModeReverse" }
      )
    end
  }
)
