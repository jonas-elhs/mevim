local group = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Show Cursorline Only In Current Window
local cursorline_group = group("jonas/cursorline", {})
autocmd({ "VimEnter", "WinEnter", "BufWinEnter", "TermLeave" }, {
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

-- Highlight Yank Region
local yank_highlight_group = group("jonas/yank_highlight", {})
autocmd({ "TextYankPost" }, {
  group = yank_highlight_group,
  callback = function()
    vim.hl.on_yank()
  end,
})
