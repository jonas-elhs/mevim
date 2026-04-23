-- Columns
vim.o.number = true
vim.o.signcolumn = "yes"

-- Scrolling
vim.o.scrolloff = 999
vim.o.scrolloffpad = 1
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
vim.o.showtabline = 2

-- UI
vim.o.wrap = false
vim.o.cmdheight = 0
vim.o.winborder = "rounded"
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.termguicolors = true
vim.o.cursorlineopt = "number"

-- Files
vim.o.undofile = true
vim.o.swapfile = false
vim.o.shadafile = "NONE"

-- Line Wrapping
vim.o.wrap = false
vim.o.showbreak = "󱞩"
vim.o.linebreak = true
vim.o.breakindent = true

-- Disable Builtin Plugins
vim.g.loaded_netrw = 1
vim.g.loaded_matchparen = 1
vim.g.loaded_matchit = 1
vim.g.loaded_rrhelper = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_gzip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_shada_plugin = 1
vim.g.loaded_spellfile_plugin = 1
vim.g.loaded_tutor_mode_plugin = 1
vim.g.loaded_remote_plugins = 1
