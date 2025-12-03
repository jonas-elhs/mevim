local map = vim.keymap.set

-- stylua: ignore start

map({ "n", "v" },   " ",            "<NOP>")

-- Write and Quit
map("n",   "<leader>w",    "<CMD>write<CR>",                 { desc = "Write buffer" })
map("n",   "<leader>W",    "<CMD>write!<CR>",                { desc = "Force write buffer" })
map("n",   "<leader>q",    "<CMD>quitall<CR>",               { desc = "Quit neovim" })
map("n",   "<leader>Q",    "<CMD>quitall!<CR>",              { desc = "Force quit neovim" })

-- Utilities
map("n",   "<ESC>",        "<CMD>nohl<CR>",                  { desc = "Remove search highlights" })
map("n",   "U",            "<C-r>",                          { desc = "Redo previously undone changes" })
map("v",   "p",            "\"_p",                           { desc = "Overpaste selection" })
map("n",   "x",            "\"_x",                           { desc = "Delete character under cursor" })
map("v",   "<",            "<gv",                            { desc = "Indent staying in visual mode" })
map("v",   ">",            ">gv",                            { desc = "De-indent staying in visual mode" })

-- Insert Mode Cursor Movement
map("i",   "<C-h>",        "<Left>",                         { desc = "Move cursor left (Insert Mode)" })
map("i",   "<C-j>",        "<Down>",                         { desc = "Move cursor down (Insert Mode)" })
map("i",   "<C-k>",        "<Up>",                           { desc = "Move cursor up (Insert Mode)" })
map("i",   "<C-l>",        "<Right>",                        { desc = "Move cursor right (Insert Mode)" })

-- Buffer Management
map("n",   "[b",           "<CMD>bprev<CR>",                 { desc = "Open previous buffer" })
map("n",   "]b",           "<CMD>bnext<CR>",                 { desc = "Open next buffer" })
map("n",   "<leader>x",    "<CMD>bdelete<CR>",               { desc = "Exit open buffer" })
map("n",   "<leader>X",    "<CMD>bdelete!<CR>",              { desc = "Force exit open buffer" })

-- Traverse Code
map("n",   "[e",           function()
  vim.diagnostic.jump({count = -1, severity = vim.diagnostic.severity.ERROR })
end,                                                                                  { desc = "Go to previous error" })
map("n",   "]e",           function()
  vim.diagnostic.jump({count = 1, severity = vim.diagnostic.severity.ERROR })
end,                                                                                  { desc = "Go to next error" })

-- Split Creation
map("n",   "<leader>sh",   "<CMD>wincmd v<CR>",              { desc = "Split left" })
map("n",   "<leader>sj",   "<CMD>wincmd s | wincmd j<CR>",   { desc = "Split down" })
map("n",   "<leader>sk",   "<CMD>wincmd s<CR>",              { desc = "Split up" })
map("n",   "<leader>sl",   "<CMD>wincmd v | wincmd l<CR>",   { desc = "Split right" })
map("n",   "<leader>sx",   "<CMD>close<CR>",                 { desc = "Exit split" })

-- Split Movement
map("n",   "<C-h>",        "<CMD>wincmd h<CR>",              { desc = "Focus split left" })
map("n",   "<C-j>",        "<CMD>wincmd j<CR>",              { desc = "Focus split below" })
map("n",   "<C-k>",        "<CMD>wincmd k<CR>",              { desc = "Focus split above" })
map("n",   "<C-l>",        "<CMD>wincmd l<CR>",              { desc = "Focus split right" })

-- Split Sizing
map("n",   "<C-Left>",     "<CMD>wincmd <<CR>",              { desc = "Decrease split width" })
map("n",   "<C-Down>",     "<CMD>wincmd -<CR>",              { desc = "Decrease split heigth" })
map("n",   "<C-Up>",       "<CMD>wincmd +<CR>",              { desc = "Increase split height" })
map("n",   "<C-Right>",    "<CMD>wincmd ><CR>",              { desc = "Increase split width" })

-- stylua: ignore end
