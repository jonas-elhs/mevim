local map = vim.keymap.set

-- stylua: ignore start

map("",    " ",            "<NOP>")

-- Write and Quit
map("n",   "<leader>w",    "<CMD>write<CR>",              { desc = "Write" })
map("n",   "<leader>W",    "<CMD>write!<CR>",             { desc = "Force write" })
map("n",   "<leader>q",    "<CMD>quitall<CR>",            { desc = "Quit" })
map("n",   "<leader>Q",    "<CMD>quitall!<CR>",           { desc = "Force quit" })

-- Utilities
map("n",   "<ESC>",        "<CMD>nohl<CR>",               { desc = "Remove search highlights" })
map("n",   "U",            "<C-r>",                       { desc = "Redo" })
map("n",   "x",            "\"_x",                        { desc = "Delete character" })
map("x",   "p",            "\"_p",                        { desc = "Overpaste selection" })

-- LSP
map("n",   "<leader>lr",   vim.lsp.buf.rename,            { desc = "Rename" })
map("n",   "<leader>lR",   vim.lsp.buf.references,        { desc = "References" })
map("n",   "<leader>ld",   vim.lsp.buf.definition,        { desc = "Definition" })
map("n",   "<leader>la",   vim.lsp.buf.code_action,       { desc = "Code Actions" })
map("n",   "<leader>li",   vim.lsp.buf.implementation,    { desc = "Implementation" })
map("n",   "<leader>lt",   vim.lsp.buf.type_definition,   { desc = "Type Defintion" })
map("n",   "<leader>lD",   vim.diagnostic.open_float,     { desc = "Diagnostic popup" })

-- Insert Mode Cursor Movement
map("i",   "<C-h>",        "<Left>",                      { desc = "Left (Insert Mode)" })
map("i",   "<C-j>",        "<Down>",                      { desc = "Down (Insert Mode)" })
map("i",   "<C-k>",        "<Up>",                        { desc = "Up (Insert Mode)" })
map("i",   "<C-l>",        "<Right>",                     { desc = "Right (Insert Mode)" })

-- Split Creation
map("n",   "<leader>sh",   "<C-w>v",                      { desc = "Split left" })
map("n",   "<leader>sj",   "<C-w>s<C-w>j",                { desc = "Split down" })
map("n",   "<leader>sk",   "<C-w>s<CR>",                  { desc = "Split up" })
map("n",   "<leader>sl",   "<C-w>v<C-w>l",                { desc = "Split right" })
map("n",   "<leader>sx",   "<C-w>c",                      { desc = "Exit split" })

-- Split Movement
map("n",   "<C-h>",        "<C-w>h",                      { desc = "Focus left split" })
map("n",   "<C-j>",        "<C-w>j",                      { desc = "Focus below split" })
map("n",   "<C-k>",        "<C-w>k",                      { desc = "Focus above split" })
map("n",   "<C-l>",        "<C-w>l",                      { desc = "Focus right split" })

-- Split Sizing
map("n",   "<C-Left>",     "<C-w><",                      { desc = "Decrease split width" })
map("n",   "<C-Down>",     "<C-w>-",                      { desc = "Decrease split heigth" })
map("n",   "<C-Up>",       "<C-w>+",                      { desc = "Increase split height" })
map("n",   "<C-Right>",    "<C-w>>",                      { desc = "Increase split width" })

-- Traverse Errors
map("n",   "[e",           function()
  vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR })
end,                                              { desc = "Go to previous error" })
map("n",   "]e",           function()
  vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR })
end,                                              { desc = "Go to next error" })

-- stylua: ignore end
