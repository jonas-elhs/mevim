require("snacks").setup({
  image = {
    enabled = true,
  },

  input = {
    enabled = true,
  },

  scroll = {
    enabled = true,

    animate = {
      duration = {
        step = 10,
        total = 100,
      },
    },
  },

  picker = {
    enabled = true,
  },

  indent = {
    enabled = true,

    scope = {
      only_current = true,
    },
  },

  bigfile = {
    enabled = true,
  },

  notifier = {
    enabled = true,
  },

  dashboard = {
    enabled = true,
    preset = {
      header = [[
                                                                    
      ████ ██████           █████      ██                     
     ███████████             █████                             
     █████████ ███████████████████ ███   ███████████   
    █████████  ███    █████████████ █████ ██████████████   
   █████████ ██████████ █████████ █████ █████ ████ █████   
 ███████████ ███    ███ █████████ █████ █████ ████ █████  
██████  █████████████████████ ████ █████ █████ ████ ██████ 
                                                                     ]],
      -- stylua: ignore
      keys = {
        { icon = "󰍉",   desc = "Find Files",      key = "f",   action = "<CMD>lua Snacks.picker.files()<CR>", },
        { icon = "",   desc = "New File",        key = "n",   action = "<CMD>ene | startinsert<CR>", },
        { icon = "󰦨",   desc = "Find Text",       key = "g",   action = "<CMD>lua Snacks.picker.grep()<CR>", },
        { icon = "",   desc = "Explore Files",   key = "e",   action = "<CMD>MiniFilesFullscreen 0<CR>" },
        { icon = "",   desc = "Config",          key = "c",   action = "<CMD>lua vim.cmd.cd(vim.fn.stdpath('config')); Snacks.picker.files()<CR>", },
        { icon = "󰈆",   desc = "Quit",            key = "q",   action = "<CMD>qa<CR>" },
      },
    },
    sections = {
      { section = "header", padding = 3 },
      { section = "keys", gap = 1, padding = 10 },
    },
  },

  statuscolumn = {
    enabled = true,

    left = {},
    right = { "sign", "mark", "fold" },

    folds = {
      open = true,
    },
  },
})

-- Picker
vim.keymap.set("n", "<leader>sf", function()
  Snacks.picker.files()
end, { desc = "Search files" })
vim.keymap.set("n", "<leader>sg", function()
  Snacks.picker.grep()
end, { desc = "Search text" })
vim.keymap.set("n", "<leader>sc", function()
  Snacks.picker.grep_word()
end, { desc = "Search word under cursor" })
vim.keymap.set("n", "<leader>sb", function()
  Snacks.picker.buffers()
end, { desc = "Search buffers" })
vim.keymap.set("n", "<leader>sr", function()
  Snacks.picker.resume()
end, { desc = "Resume search" })

-- BufDelete
vim.keymap.set("n", "<leader>bx", function()
  Snacks.bufdelete.delete()
end, { desc = "Exit open buffer" })
vim.keymap.set("n", "<leader>bX", function()
  Snacks.bufdelete.delete({ force = true })
end, { desc = "Force exit open buffer" })

-- LazyGit
vim.keymap.set("n", "<leader>g", function()
  Snacks.lazygit.open()
end, { desc = "Open LazyGit" })

-- Notifier
vim.keymap.set("n", "<leader>m", function()
  Snacks.notifier.show_history()
end, { desc = "Show notification history" })
