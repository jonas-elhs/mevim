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

  bigfile = {
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
      keys = {
        { icon = "󰍉", desc = "Find Files", key = "<Space>", action = "<CMD>Pick files<CR>" },
        { icon = "󰦨", desc = "Find Text", key = "/", action = "<CMD>Pick grep_live<CR>" },
        { icon = "", desc = "Explore Files", key = "e", action = "<CMD>lua MiniFiles.open()<CR>" },
        { icon = "", desc = "New File", key = "n", action = "<CMD>ene | startinsert<CR>" },
        { icon = "󰈆", desc = "Quit", key = "q", action = "<CMD>qa<CR>" },
      },
    },
    sections = {
      { section = "header", padding = 3 },
      { section = "keys", gap = 1, padding = 10 },
    },
  },

  statuscolumn = {
    enabled = true,

    left = { "git" },
    right = { "sign", "mark", "fold" },

    folds = {
      open = true,
    },
  },
})

-- LazyGit
vim.keymap.set("n", "<leader>g", Snacks.lazygit.open, { desc = "Open LazyGit" })
