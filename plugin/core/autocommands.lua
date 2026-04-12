local group = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Enable Tree-Sitter
local treesitter = group("jonas/treesitter", {})
autocmd("FileType", {
  group = treesitter,
  callback = function()
    local started = pcall(vim.treesitter.start)

    if not started then
      return
    end

    vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.o.foldmethod = "expr"

    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

-- Current window only
local cursorline = group("jonas/currentwindow", {})
autocmd({ "VimEnter", "WinEnter", "BufWinEnter", "TermLeave" }, {
  group = cursorline,
  callback = function()
    vim.wo.cursorline = true
  end,
})
autocmd({ "WinLeave" }, {
  group = cursorline,
  callback = function()
    vim.wo.cursorline = false
  end,
})

-- Highlight Yank Region
local yank_highlight = group("jonas/yank_highlight", {})
autocmd({ "TextYankPost" }, {
  group = yank_highlight,
  callback = function()
    vim.hl.on_yank()
  end,
})

-- https://www.reddit.com/r/neovim/comments/1qu6060/how_can_i_disable_the_feature_that_gets_rid_of/
-- Don't get rid of autoindent when switching to normal mode or moving cursor
local function apply_ts_indent_if_blank()
  local buf = vim.api.nvim_get_current_buf()
  local lnum = vim.api.nvim_win_get_cursor(0)[1]
  local line = vim.api.nvim_buf_get_lines(buf, lnum - 1, lnum, false)[1]
  if line ~= "" then
    return
  end
  -- check if indentexpr is set before evaluating
  local indentexpr = vim.bo.indentexpr
  if indentexpr == "" or indentexpr == nil then
    return
  end
  -- get indent from indentexpr (Tree-sitter or fallback)
  local old_lnum = vim.v.lnum
  vim.v.lnum = lnum
  local indent = vim.fn.eval(vim.bo.indentexpr)
  vim.v.lnum = old_lnum
  if indent > 0 then
    vim.api.nvim_buf_set_lines(buf, lnum - 1, lnum, false, { string.rep(" ", indent) })
  end
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("$", true, false, true), "n", true)
end
-- apply indent on InsertLeave
autocmd("InsertLeave", {
  callback = apply_ts_indent_if_blank,
})
-- apply indent in insert cursor move
autocmd("CursorMovedI", {
  callback = function()
    -- stoe the line we're leaving
    local buf = vim.api.nvim_get_current_buf()
    local prev_line = vim.b.previous_insert_line or 0
    local current_line = vim.api.nvim_win_get_cursor(0)[1]
    -- if moved, restore on previous line
    if prev_line ~= current_line and prev_line > 0 then
      local line = vim.api.nvim_buf_get_lines(buf, prev_line - 1, prev_line, false)[1]
      if line == "" then
        local old_lnum = vim.v.lnum
        vim.v.lnum = prev_line
        local indent = vim.fn.eval(vim.bo.indentexpr)
        vim.v.lnum = old_lnum
        if indent > 0 then
          vim.api.nvim_buf_set_lines(buf, prev_line - 1, prev_line, false, { string.rep(" ", indent) })
        end
      end
    end
    -- store current line for future
    vim.b.previous_insert_line = current_line
  end,
})

-- Resize splits if window is resized
local resize = group("jonas/resize_splits", {})
autocmd("VimResized", {
  group = resize,
  callback = function()
    local current = vim.api.nvim_get_current_tabpage()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current)
  end,
})

-- Easy close
local close = group("jonas/easy_close", {})
autocmd("FileType", {
  group = close,
  pattern = {
    "qf",
    "help",
    "notify",
    "startuptime",
    "checkhealth",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<CMD>close<CR>", {
      buf = event.buf,
      silent = true,
      desc = "Close Buffer",
    })
  end,
})

-- Create parent dir if it doesn't exist
local parent_dir = group("jonas/create_parent_dir", {})
autocmd("BufWritePre", {
  group = parent_dir,
  callback = function(event)
    if event.match:match("^%w%w+://") then
      return
    end

    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})
