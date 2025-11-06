return {
  {
    "oil.nvim",

    event = "DeferredUIEnter",
    cmd = "Oil",
    keys = {
      { "<leader>e", "<CMD>Oil --float<CR>", desc = "Explore parent direcotry in Oil" },
    },

    after = function()
      require("oil").setup({
        default_file_explorer = true,
        skip_confirm_for_simple_edits = true,
        view_options = {
          show_hidden = true,
          natural_order = true,
          is_always_hidden = function(name, _)
            return name == ".."
          end,
        },
        win_options = {
          wrap = true,
          winblend = 0,
        },
        keymaps = {
          ["<C-c>"] = false,
          ["q"] = "actions.close",
        },
        float = {
          padding = 0,
          override = function(config)
            local left_padding = 10
            local bottom_padding = 4
            local top_padding = 3
            local right_padding = 10

            config.col = left_padding
            config.width = config.width - left_padding - right_padding
            config.row = top_padding
            config.height = config.height - bottom_padding - top_padding

            return config
          end
        },
      })
    end,
  },
}
