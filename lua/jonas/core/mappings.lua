local map = vim.keymap.set

-- stylua: ignore start

map({ "n", "v" },   " ",            "<NOP>")

-- Write and Quit
map("n",   "<leader>w",    "<CMD>write<CR>",      { desc = "Write buffer" })
map("n",   "<leader>W",    "<CMD>write!<CR>",     { desc = "Force write buffer" })
map("n",   "<leader>q",    "<CMD>quitall<CR>",    { desc = "Quit neovim" })
map("n",   "<leader>Q",    "<CMD>quitall!<CR>",   { desc = "Force quit neovim" })

-- Utilities
map("n",   "<ESC>",        "<CMD>nohl<CR>",       { desc = "Remove search highlights" })
map("n",   "U",            "<C-r>",               { desc = "Redo previously undone changes" })
map("v",   "p",            "\"_p",                { desc = "Overpaste selection" })
map("n",   "x",            "\"_x",                { desc = "Delete character under cursor" })
map("v",   "<",            "<gv",                 { desc = "Indent staying in visual mode" })
map("v",   ">",            ">gv",                 { desc = "De-indent staying in visual mode" })

-- Insert Mode Cursor Movement
map("i",   "<C-h>",        "<Left>",              { desc = "Move cursor left (Insert Mode)" })
map("i",   "<C-j>",        "<Down>",              { desc = "Move cursor down (Insert Mode)" })
map("i",   "<C-k>",        "<Up>",                { desc = "Move cursor up (Insert Mode)" })
map("i",   "<C-l>",        "<Right>",             { desc = "Move cursor right (Insert Mode)" })

-- Traverse Through Errors
map("n",   "[e",           function()
  vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR })
end,                                              { desc = "Go to previous error" })
map("n",   "]e",           function()
  vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR })
end,                                              { desc = "Go to next error" })

-- Split Creation
map("n",   "<leader>sh",   "<C-w>v",              { desc = "Split left" })
map("n",   "<leader>sj",   "<C-w>s<C-w>j",        { desc = "Split down" })
map("n",   "<leader>sk",   "<C-w>s<CR>",          { desc = "Split up" })
map("n",   "<leader>sl",   "<C-w>v<C-w>l",        { desc = "Split right" })
map("n",   "<leader>sx",   "<C-w>c",              { desc = "Exit split" })

-- Split Movement
map("n",   "<C-h>",        "<C-w>h",              { desc = "Focus split left" })
map("n",   "<C-j>",        "<C-w>j",              { desc = "Focus split below" })
map("n",   "<C-k>",        "<C-w>k",              { desc = "Focus split above" })
map("n",   "<C-l>",        "<C-w>l",              { desc = "Focus split right" })

-- Split Sizing
map("n",   "<C-Left>",     "<C-w><",              { desc = "Decrease split width" })
map("n",   "<C-Down>",     "<C-w>-",              { desc = "Decrease split heigth" })
map("n",   "<C-Up>",       "<C-w>+",              { desc = "Increase split height" })
map("n",   "<C-Right>",    "<C-w>>",              { desc = "Increase split width" })

-- stylua: ignore end
