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

  ignore = {
    unlisted_buffers = false,
    buftypes = { "acwrite", "nofile", "nowrite", "prompt" },
  },

  render = function(props)
    local icons = require("mini.icons")
    local focused = props.focused

    local content_highlight = focused and "JonasCurrentMode" or "JonasInactive"
    local separator_highlight = content_highlight .. "Reverse"

    local modified = vim.bo[props.buf].modified
    local file_name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
    local icon = icons.get("file", file_name)

    return {
      { "", group = separator_highlight },

      {
        icon and { " ", icon } or "",

        " ",

        file_name ~= "" and file_name or "[No Name]",
        modified and " " or "",

        " ",

        group = content_highlight,
      },

      { "", group = separator_highlight },
    }
  end,
})
