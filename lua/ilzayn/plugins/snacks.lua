return {
  {
    "snacks.nvim",

    lazy = false,

    after = function()
      require("snacks").setup({
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
              {
                icon = "󰍉",
                desc = "Find Files",
                key = "f",
                action = "<CMD>lua Snacks.picker.files()<CR>",
              },
              {
                icon = "",
                desc = "New File",
                key = "n",
                action = "<CMD>ene | startinsert<CR>",
              },
              {
                icon = "󰦨",
                desc = "Find Text",
                key = "g",
                action = "<CMD>lua Snacks.picker.grep()<CR>",
              },
              {
                icon = "",
                desc = "Explore Files",
                key = "e",
                action = "<CMD>Oil --float<CR>",
              },
              {
                icon = "",
                desc = "Config",
                key = "c",
                action = "<CMD>lua vim.cmd.cd(vim.fn.stdpath('config')); vim.cmd('Oil --float')<CR>",
              },
              {
                icon = "󰈆",
                desc = "Quit",
                key = "q",
                action = "<CMD>qa<CR>",
              },
            },
          },
          sections = {
            { section = "header", padding = 3 },
            { section = "keys", gap = 1, padding = 10 },
          },
        },

        indent = {
          enabled = true,
        },

        notifier = {
          enabled = true,
        },

        quickfile = {
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

        statuscolumn = {
          enabled = true,

          left = { "git" },
          right = { "mark", "sign", "fold" },

          folds = {
            open = true,
          },
        },
      })

      local map = require("ilzayn.utils").keymap

      -- Picker
      map("n", "<leader>sf", function() Snacks.picker.files() end, "Search files")
      map("n", "<leader>sg", function() Snacks.picker.grep() end, "Search text")
      map("n", "<leader>sc", function() Snacks.picker.grep_word() end, "Search word under cursor")
      map("n", "<leader>sb", function() Snacks.picker.buffers() end, "Search buffers")
      map("n", "<leader>sr", function() Snacks.picker.resume() end, "Resume search")

      -- BufDelete
      map("n", "<leader>bx", function() Snacks.bufdelete.delete() end, "Exit open buffer")
      map("n", "<leader>bX", function() Snacks.bufdelete.delete({ force = true }) end, "Force exit open buffer")

      -- LazyGit
      map("n", "<leader>g", function() Snacks.lazygit.open() end, "Open LazyGit")
    end,
  },
}
