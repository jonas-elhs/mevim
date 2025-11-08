local map = require("ilzayn.utils").keymap.map

map({ "n", "v" },   " ",            "<NOP>")

-- Write and Quit
map("n",            "<leader>w",    "<CMD>w<CR>",                     "Write buffer")
map("n",            "<leader>W",    "<CMD>w!<CR>",                    "Force write buffer")
map("n",            "<leader>q",    "<CMD>q<CR>",                     "Quit window")
map("n",            "<leader>Q",    "<CMD>q!<CR>",                    "Force quit window")

-- Utilities
map("n",            "<ESC>",        "<CMD>nohl<CR>",                  "Remove search highlights")
map("n",            "U",            "<C-r>",                          "Redo previously undone changes")
map("v",            "p",            "\"_p",                           "Overpaste selection")
map("n",            "x",            "\"_x",                           "Delete character under cursor")

-- Insert Mode Cursor Movement
map("i",            "<C-h>",        "<Left>",                         "Move cursor left (Insert Mode)")
map("i",            "<C-j>",        "<Down>",                         "Move cursor down (Insert Mode)")
map("i",            "<C-k>",        "<Up>",                           "Move cursor up (Insert Mode)")
map("i",            "<C-l>",        "<Right>",                        "Move cursor right (Insert Mode)")

-- Buffer Management
map("n",            "<leader>bn",   "<CMD>bnext<CR>",                 "Open next buffer")
map("n",            "<leader>bp",   "<CMD>bprev<CR>",                 "Open previous buffer")
map("n",            "<leader>bx",   "<CMD>bdelete<CR>",               "Exit open buffer")
map("n",            "<leader>bX",   "<CMD>bdelete!<CR>",              "Force exit open buffer")

-- Split Creation
map("n",            "<leader>sh",   "<CMD>wincmd v<CR>",              "Split left")
map("n",            "<leader>sj",   "<CMD>wincmd s | wincmd j<CR>",   "Split down")
map("n",            "<leader>sk",   "<CMD>wincmd s<CR>",              "Split up")
map("n",            "<leader>sl",   "<CMD>wincmd v | wincmd l<CR>",   "Split right")
map("n",            "<leader>sx",   "<CMD>close<CR>",                 "Exit split")

-- Split Movement
map("n",            "<C-h>",        "<CMD>wincmd h<CR>",              "Focus split left")
map("n",            "<C-j>",        "<CMD>wincmd j<CR>",              "Focus split below")
map("n",            "<C-k>",        "<CMD>wincmd k<CR>",              "Focus split above")
map("n",            "<C-l>",        "<CMD>wincmd l<CR>",              "Focus split right")

-- Split Sizing
map("n",            "<C-Left>",     "<CMD>wincmd <<CR>",              "Decrease split width")
map("n",            "<C-Down>",     "<CMD>wincmd -<CR>",              "Decrease split heigth")
map("n",            "<C-Up>",       "<CMD>wincmd +<CR>",              "Increase split height")
map("n",            "<C-Right>",    "<CMD>wincmd ><CR>",              "Increase split width")
