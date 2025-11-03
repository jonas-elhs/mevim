return {
  {
    "incline.nvim",

    lazy = false,

    after = function()
      require("incline").setup({
        window = {
          padding = 0,
          margin = {
            vertical = 0,
            horizontal = 0,
          },
        },

        hide = {
          only_win = "count_ignored",
        },

        render = function(props)
          local utils = require("ilzayn.utils")
          local devicons = require("nvim-web-devicons")
          local focused = props.focused

          local content_highlight = focused and "IlzaynMode" or "IlzaynInactive"
          local separator_highlight = utils.highlight.reverse_group(content_highlight)
          local modified = vim.bo[props.buf].modified
          local file_name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t") or "[No Name]"
          local icon = devicons.get_icon(file_name)

          return {
            { utils.highlight.separators.left, group = separator_highlight },

            {
              icon and { " ", icon } or "",

              " ",

              file_name,
              modified and table.concat({ " ", utils.file.flags.modified }) or "",

              " ",

              group = content_highlight,
            },

            { utils.highlight.separators.right, group = separator_highlight },
          }
        end,
      })
    end,
  },
}
