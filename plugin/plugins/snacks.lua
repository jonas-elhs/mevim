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

    sources = {
      files = {
        hidden = true,
        ignored = true,
        exclude = {
          "**/.jj/*",
          "**/.git/*",
          "**/node_modules/*",
          "**/.yarn/cache/*",
          "**/.yarn/install/*",
          "**/.yarn/releases/*",
          "**/.pnpm-store/*",
          "**/idea/*",
          "**/.DS_Store",
          "build/*",
          "dist/*",
          "**/target/*",
        },
      },
      grep = {
        hidden = true,
        ignored = true,
        exclude = {
          "**/.jj/*",
          "**/.git/*",
          "**/node_modules/*",
          "**/.yarn/cache/*",
          "**/.yarn/install/*",
          "**/.yarn/releases/*",
          "**/.pnpm-store/*",
          "**/idea/*",
          "**/.DS_Store",
          "build/*",
          "dist/*",
          "**/target/*",
        },
      },

      explorer = {
        layout = {
          auto_hide = { "input" },
          layout = { width = vim.o.columns / 5, position = "right" },
        },
      },
    },
  },

  bigfile = {
    enabled = true,
  },

  explorer = {
    replace_netrw = false,
    trash = false,
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
        { icon = "",   desc = "Explore Files",   key = "e",   action = "<CMD>lua MiniFiles.open()<CR>" },
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

    left = { "git" },
    right = { "sign", "mark", "fold" },

    folds = {
      open = true,
    },
  },
})

-- Picker
local map = vim.keymap.set

map("n", "<leader>sg", Snacks.picker.grep, { desc = "Search text" })
map("n", "<leader>sf", Snacks.picker.files, { desc = "Search files" })
map("n", "<leader>sr", Snacks.picker.resume, { desc = "Resume search" })
map("n", "<leader>sm", Snacks.picker.keymaps, { desc = "Search mappings" })
map("n", "<leader>sb", Snacks.picker.buffers, { desc = "Search buffers" })
map("n", "<leader>sc", Snacks.picker.grep_word, { desc = "Search word under cursor" })

map("n", "gr", Snacks.picker.lsp_references, { desc = "LSP references" })
map("n", "gd", Snacks.picker.lsp_definitions, { desc = "LSP definitions" })
map("n", "gD", Snacks.picker.lsp_declarations, { desc = "LSP declarations" })
map("n", "gi", Snacks.picker.lsp_implementations, { desc = "LSP implementations" })
map("n", "gt", Snacks.picker.lsp_type_definitions, { desc = "LSP type definitions" })
map("n", "<leader>ls", Snacks.picker.lsp_symbols, { desc = "LSP symbols" })

-- BufDelete
map("n", "<leader>x", Snacks.bufdelete.delete, { desc = "Exit open buffer" })
map("n", "<leader>X", function()
  Snacks.bufdelete.delete({ force = true })
end, { desc = "Force exit open buffer" })

-- LazyGit
map("n", "<leader>g", Snacks.lazygit.open, { desc = "Open LazyGit" })

-- Notifier
map("n", "<leader>n", Snacks.notifier.hide, { desc = "Dismiss all notifications" })
map("n", "<leader>m", Snacks.notifier.show_history, { desc = "Show notification history" })

-- Explorer
map("n", "<leader><leader>", Snacks.explorer.open)
