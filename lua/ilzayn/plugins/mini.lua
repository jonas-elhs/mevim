return {
  {
    "mini.diff",

    after = function()
      require("mini.diff").setup({})
    end,
  },
  {
    "mini.icons",

    on_require = { "mini.icons" },
    beforeAll = function()
      _G.MiniIcons = setmetatable({}, {
        __index = function(_, key)
          return function(...)
            require("mini.icons")[key](...)
          end
        end,
      })
    end,

    after = function()
      require("mini.icons").setup()
      require("mini.icons").mock_nvim_web_devicons()
    end,
  },
  {
    "mini.files",

    on_require = { "mini.files" },
    beforeAll = function()
      _G.MiniFiles = setmetatable({}, {
        __index = function(_, key)
          return function(...)
            require("mini.files")[key](...)
          end
        end,
      })
    end,

    keys = {
      {
        "<leader>e",
        function()
          require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
        end,
        desc = "Open current directory in mini.files",
      },
      {
        "<leader>E",
        function()
          require("mini.files").open(vim.uv.cwd(), true)
        end,
        desc = "Open current working directory in mini.files",
      },
    },

    after = function()
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
          go_out = "",
          go_out_plus = "h",
          mark_goto = "",
          mark_set = "",
          reset = "",
          reveal_cwd = "@",
          show_help = "g?",
          synchronize = "=",
          trim_left = "",
          trim_right = "",
        },
      })

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

      require("ilzayn.plugins.mini-files-git").setup()
    end,
  },
  {
    "mini.surround",

    keys = { "gsa", "gsd", "gsr" },

    after = function()
      require("mini.surround").setup({
        mappings = {
          add = "gsa",
          delete = "gsd",
          replace = "gsr",
          find = "",
          find_left = "",
          highlight = "",
        },

        silent = true,
      })
    end,
  },
}
