-- mini.files
require("mini.files").setup({
  windows = {
    preview = true,
    width_nofocus = 20,
    width_preview = 80,
  },
  mappings = {
    close = "q",
    go_in = "",
    go_in_plus = "l",
    go_out = "h",
    go_out_plus = "",
    mark_goto = "",
    mark_set = "",
    reset = "",
    reveal_cwd = "@",
    show_help = "?",
    synchronize = "=",
    trim_left = "",
    trim_right = "",
  },
})

require("jonas.plugins.mini-files-git")

vim.api.nvim_create_autocmd("User", {
  pattern = "MiniFilesBufferCreate",
  callback = function(args)
    local buffer = args.data.buf_id

    vim.keymap.set("n", "<C-H>", "<Left>", { buffer = buffer })
    vim.keymap.set("n", "<C-J>", "<Down>", { buffer = buffer })
    vim.keymap.set("n", "<C-K>", "<Up>", { buffer = buffer })
    vim.keymap.set("n", "<C-L>", "<Right>", { buffer = buffer })
  end,
})

vim.keymap.set("n", "<leader>e", function()
  MiniFiles.open(vim.api.nvim_buf_get_name(0), true)
end, { desc = "Explore current directory" })
vim.keymap.set("n", "<leader>E", function()
  MiniFiles.open(vim.uv.cwd(), true)
end, { desc = "Explore current working directory" })

-- mini.icons
require("mini.icons").setup()

MiniIcons.mock_nvim_web_devicons()

-- mini.surround
require("mini.surround").setup({
  mappings = {
    add = "sa",
    delete = "sd",
    replace = "sr",
    find = "",
    find_left = "",
    highlight = "",
  },

  silent = true,
})

-- mini.hipatterns
require("mini.hipatterns").setup({
  highlighters = {
    fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
    hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
    todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
    note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
  },
})

-- mini.indentscope
require("mini.indentscope").setup({
  options = {
    try_as_border = true,
  },

  symbol = "│",
})
