-- Columns
vim.o.number = true
vim.o.signcolumn = "yes"
vim.o.relativenumber = true

-- Scrolling
vim.o.scrolloff = 999
vim.o.sidescrolloff = 8

-- Searching
vim.o.ignorecase = true
vim.o.smartcase = true

-- Indenting
vim.o.tabstop = 2
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.smartindent = true

-- Editing
vim.o.undofile = true
vim.o.clipboard = "unnamedplus"
vim.o.virtualedit = "block"

-- Folding
vim.o.foldopen = "mark,quickfix,search,tag,undo"
vim.o.foldtext = ""
vim.o.foldmethod = "indent"
vim.o.foldlevelstart = 99

-- Editor
vim.o.list = true
vim.o.confirm = true
vim.o.listchars = "tab:» ,trail:·,extends:…,precedes:…,nbsp:␣"
vim.o.fillchars = "eob: ,foldopen:,foldclose:,fold: ,"
vim.o.laststatus = 3
vim.o.updatetime = 50

-- UI
vim.o.wrap = false
vim.o.winborder = "rounded"
vim.o.termguicolors = true
vim.o.cursorlineopt = "number"

-- Disable Netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
