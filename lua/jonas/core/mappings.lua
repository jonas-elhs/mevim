local map = vim.keymap.set
local unmap = vim.keymap.del

-- stylua: ignore start

map("",    " ",            "<NOP>")

-- Write and Quit
map("n",   "<leader>w",    "<CMD>silent write<CR>",       { desc = "Write" })
map("n",   "<leader>W",    "<CMD>silent write!<CR>",      { desc = "Force write" })
map("n",   "<leader>q",    "<CMD>quitall<CR>",            { desc = "Quit" })
map("n",   "<leader>Q",    "<CMD>quitall!<CR>",           { desc = "Force quit" })

-- Yank, Delete And Paste System Clipboard
map({ "n", "x" },   "<leader>p",    "\"+p",               { desc = "Paste from clipboard" })
map({ "n", "x" },   "<leader>P",    "\"+P",               { desc = "Paste from clipboard" })
map({ "n", "x" },   "<leader>y",    "\"+y",               { desc = "Yank to clipboard" })
map({ "n", "x" },   "<leader>Y",    "\"+Y",               { desc = "Yank to clipboard" })
map({ "n", "x" },   "<leader>d",    "\"+d",               { desc = "Cut to clipboard" })
map({ "n", "x" },   "<leader>D",    "\"+D",               { desc = "Cut to clipboard" })

-- Tabs
map("n",   "<leader>tn",   "<CMD>tabnew<CR>",             { desc = "New tab" })
map("n",   "<leader>tx",   "<CMD>tabclose<CR>",           { desc = "Close tab" })
map("n",   "[t",           "<CMD>tabprevious<CR>",        { desc = "Previous tab" })
map("n",   "]t",           "<CMD>tabnext<CR>",            { desc = "Next tab" })
map("n",   "<leader>th",   "<CMD>tabmove -<CR>",          { desc = "Move tab left" })
map("n",   "<leader>tl",   "<CMD>tabmove +<CR>",          { desc = "Move tab right" })

for i=1,9 do
  map("n", "<leader>t" .. i, "<CMD>tabnext " .. i .. "<CR>", { desc = "Go to tab " .. i })
end

-- LSP
map("n",   "<leader>lr",   vim.lsp.buf.rename,            { desc = "Rename" })
map("n",   "<leader>la",   vim.lsp.buf.code_action,       { desc = "Code Actions" })
map("n",   "<leader>ld",   vim.diagnostic.open_float,     { desc = "Diagnostic popup" })

unmap("n", "grn")
unmap("n", "grx")
unmap("n", "grr")
unmap("n", "gri")
unmap("n", "grt")
unmap({ "n", "x" }, "gra")

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

-- Misc
map("n",   "<ESC>",        "<CMD>nohl<CR>",               { desc = "Remove search highlights" })
map("n",   "U",            "<C-r>",                       { desc = "Redo" })
map("n",   "x",            "\"_x",                        { desc = "Delete character" })
map("x",   "p",            "\"_p",                        { desc = "Overpaste selection" })
map("n",   "j",            "gj",                          { desc = "Down" })
map("n",   "k",            "gk",                          { desc = "Down" })
map("n",   "<leader>R",    function()
  local session = vim.fn.stdpath("state") .. "/restart_session.vim"
  vim.cmd("mksession! " .. session)
  vim.cmd("restart source " .. session)
end, { desc = "Restart Neovim" })

-- stylua: ignore end
