-- credit to https://codeberg.org/kznleaf/dotfiles/src/commit/38eb3c2e336d79ad863de1cfb74db8c6771f097f/nvim/.config/nvim/plugin/floating-term.lua

local state = {
  floating = {
    buf = -1,
    win = -1,
  },
}

local function create_floating_window(opts)
  opts = opts or {}
  local width = opts.width or math.ceil(math.min(vim.o.columns, math.max(80, vim.o.columns - 20)))
  local height = opts.height or math.ceil(math.min(vim.o.lines, math.max(20, vim.o.lines - 10)))

  -- Calculate the position to center the window
  local col = math.ceil(vim.o.columns - width) * 0.5 - 1
  local row = math.ceil(vim.o.lines - height) * 0.5 - 1

  -- Create a buffer
  local buf = nil
  if vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(false, true) -- No file, scratch buffer
  end

  -- Define window configuration
  local win_config = {
    relative = "editor",
    col = col,
    row = row,
    width = width,
    height = height,
    style = "minimal",
  }

  -- Create the floating window
  local win = vim.api.nvim_open_win(buf, true, win_config)

  return { buf = buf, win = win }
end

local find_exist_term = function()
  local bufs = vim.api.nvim_list_bufs()
  for _, bufnr in ipairs(bufs) do
    local name = vim.api.nvim_buf_get_name(bufnr)
    if name:match("^term://") then
      state.floating.buf = bufnr
    end
  end
end

local toggle_terminal = function()
  find_exist_term()
  if not vim.api.nvim_win_is_valid(state.floating.win) then
    state.floating = create_floating_window({ buf = state.floating.buf })
    if vim.bo[state.floating.buf].buftype ~= "terminal" then
      vim.cmd.terminal()
    end
    vim.cmd("startinsert")
  else
    -- if the term has been open, then close
    vim.api.nvim_win_close(state.floating.win, true)
  end
end

vim.keymap.set({ "n", "t" }, "<C-t>", toggle_terminal, { desc = "Toggle terminal" })
