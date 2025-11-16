return {
  {
    "snacks.nvim",

    lazy = false,
    -- stylua: ignore
    keys = {
      -- Picker
      { "<leader>sf", function() Snacks.picker.files() end, desc = "Search files" },
      { "<leader>sg", function() Snacks.picker.grep() end, desc = "Search text" },
      { "<leader>sc", function() Snacks.picker.grep_word() end, desc = "Search word under cursor" },
      { "<leader>sb", function() Snacks.picker.buffers() end, desc = "Search buffers" },
      { "<leader>sr", function() Snacks.picker.resume() end, desc = "Resume search" },

      -- BufDelete
      { "<leader>bx", function() Snacks.bufdelete.delete() end, desc = "Exit open buffer" },
      { "<leader>bX", function() Snacks.bufdelete.delete({ force = true }) end, desc = "Force exit open buffer" },

      -- LazyGit
      { "<leader>g", function() Snacks.lazygit.open() end, desc = "Open LazyGit" },
    },

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
                action = "<CMD>lua MiniFiles.open()<CR>",
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

          left = {},
          right = { "mark", "sign", "fold" },

          folds = {
            open = true,
          },
        },

        image = {
          enabled = true,
        },

        input = {
          enabled = true,
        },

        picker = {
          enabled = true,
        },

        indent = {
          enabled = true,
        },

        bigfile = {
          enabled = true,
        },

        notifier = {
          enabled = true,
        },

        quickfile = {
          enabled = true,
        },
      })
    end,
  },
}
