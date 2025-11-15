local group = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Show Cursorline Only In Current Window
local cursorline_group = group("IlzaynCursorline", {})
autocmd({ "VimEnter", "WinEnter", "BufWinEnter" }, {
  group = cursorline_group,
  callback = function()
    vim.wo.cursorline = true
  end,
})
autocmd({ "WinLeave" }, {
  group = cursorline_group,
  callback = function()
    vim.wo.cursorline = false
  end,
})
