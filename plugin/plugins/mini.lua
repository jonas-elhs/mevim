local map = vim.keymap.set

-- mini.extra
require("mini.extra").setup()

-- mini.ai
local ai = require("mini.ai")

require("mini.ai").setup({ -- from LazyVim
  n_lines = 500,
  custom_textobjects = {
    o = ai.gen_spec.treesitter({ -- code block
      a = { "@block.outer", "@conditional.outer", "@loop.outer" },
      i = { "@block.inner", "@conditional.inner", "@loop.inner" },
    }),
    f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }), -- function
    c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }), -- class
    t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- tags
    d = MiniExtra.gen_ai_spec.number(), -- digits
    e = { -- Word with case
      { "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
      "^().*()$",
    },
    g = MiniExtra.gen_ai_spec.buffer(), -- buffer
    u = ai.gen_spec.function_call(), -- u for "Usage"
    U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
  },
})

-- mini.move
require("mini.move").setup()

-- mini.diff
require("mini.diff").setup({
  source = {
    require("mini.diff.jj"),
    require("mini.diff").gen_source.git(),
  },
  view = {
    style = "sign",
    signs = { add = "┃", change = "┃", delete = "┃" },
  },
})

-- mini.pick
require("mini.pick").setup({
  mappings = {
    caret_left = "<C-h>",
    caret_right = "<C-l>",

    move_down = "<C-j>",
    move_up = "<C-k>",

    scroll_left = "",
    scroll_right = "",
  },

  window = {
    config = function()
      local height = math.floor(0.8 * vim.o.lines)
      local width = math.floor(0.7 * vim.o.columns)

      return {
        anchor = "NW",
        height = height,
        width = width,
        row = math.floor(0.5 * (vim.o.lines - height)),
        col = math.floor(0.5 * (vim.o.columns - width)),
      }
    end,

    prompt_prefix = "󰁔 ",
  },
})

map("n", "<leader><leader>", MiniPick.builtin.files, { desc = "Search files" })
map("n", "<leader>/", MiniPick.builtin.grep_live, { desc = "Search text" })

map("n", "<leader>sr", MiniPick.builtin.resume, { desc = "Resume search" })
map("n", "<leader>sb", MiniPick.builtin.buffers, { desc = "Search buffers" })
map("n", "<leader>sm", MiniExtra.pickers.keymaps, { desc = "Search mappings" })
map("n", "<leader>sc", function()
  MiniPick.builtin.grep({ pattern = vim.fn.expand("<cword>") })
end, { desc = "Search word under cursor" })

map("n", "gr", function()
  MiniExtra.pickers.lsp({ scope = "references" })
end, { desc = "LSP references" })
map("n", "gd", function()
  MiniExtra.pickers.lsp({ scope = "definition" })
end, { desc = "LSP definitions" })
map("n", "gD", function()
  MiniExtra.pickers.lsp({ scope = "declaration" })
end, { desc = "LSP declarations" })
map("n", "gi", function()
  MiniExtra.pickers.lsp({ scope = "implementation" })
end, { desc = "LSP implementations" })
map("n", "gt", function()
  MiniExtra.pickers.lsp({ scope = "type_definition" })
end, { desc = "LSP type definitions" })
map("n", "<leader>ls", function()
  MiniExtra.pickers.lsp({ scope = "document_symbol" })
end, { desc = "LSP symbols" })

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
    synchronize = "<leader>w",
    trim_left = "",
    trim_right = "",
  },
})

vim.api.nvim_create_autocmd("User", {
  pattern = "MiniFilesActionRename",
  callback = function(event)
    Snacks.rename.on_rename_file(event.data.from, event.data.to)
  end,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "MiniFilesBufferCreate",
  callback = function(args)
    local buffer = args.data.buf_id

    map("n", "<C-H>", "<Left>", { buffer = buffer })
    map("n", "<C-J>", "<Down>", { buffer = buffer })
    map("n", "<C-K>", "<Up>", { buffer = buffer })
    map("n", "<C-L>", "<Right>", { buffer = buffer })
  end,
})

map("n", "<leader>e", function()
  MiniFiles.open(vim.api.nvim_buf_get_name(0), true)
end, { desc = "Explore current directory" })
map("n", "<leader>E", function()
  MiniFiles.open(vim.uv.cwd(), true)
end, { desc = "Explore current working directory" })

-- mini.icons
require("mini.icons").setup()

MiniIcons.mock_nvim_web_devicons()

-- mini.surround
require("mini.surround").setup({
  silent = true,

  mappings = {
    add = "ys",
    delete = "ds",
    replace = "cs",
    find = "",
    find_left = "",
    highlight = "",
  },
})

-- mini.hipatterns (https://github.com/nvim-mini/mini.nvim/discussions/1024)
local hipatterns = require("mini.hipatterns")

-- Returns hex color group for matching short hex color.
--
---@param match string
---@return string
local hex_color_short = function(_, match)
  local style = "fg" -- 'fg' or 'bg', for extmark_opts_inline use 'fg'
  local r, g, b = match:sub(2, 2), match:sub(3, 3), match:sub(4, 4)
  local hex = string.format("#%s%s%s%s%s%s", r, r, g, g, b, b)
  return hipatterns.compute_hex_color_group(hex, style)
end

-- Returns hex color group for matching rgb() color.
--
---@param match string
---@return string
local rgb_color = function(_, match)
  local style = "fg" -- 'fg' or 'bg', for extmark_opts_inline use 'fg'
  local red, green, blue = match:match("rgb%((%d+), ?(%d+), ?(%d+)%)")
  local hex = string.format("#%02x%02x%02x", red, green, blue)
  return hipatterns.compute_hex_color_group(hex, style)
end

-- Returns hex color group for matching rgba() color
-- or false if alpha is nil or out of range.
-- The use of the alpha value refers to a black background.
--
---@param match string
---@return string|false
local rgba_color = function(_, match)
  local style = "fg" -- 'fg' or 'bg', for extmark_opts_inline use 'fg'
  local red, green, blue, alpha = match:match("rgba%((%d+), ?(%d+), ?(%d+), ?(%d*%.?%d*)%)")
  alpha = tonumber(alpha)
  if alpha == nil or alpha < 0 or alpha > 1 then
    return false
  end
  local hex = string.format("#%02x%02x%02x", red * alpha, green * alpha, blue * alpha)
  return hipatterns.compute_hex_color_group(hex, style)
end

-- Returns extmark opts for highlights with virtual inline text.
--
---@param data table Includes `hl_group`, `full_match` and more.
---@return table
local extmark_opts_inline = function(_, _, data)
  return {
    virt_text = { { "󱓻 ", data.hl_group } },
    virt_text_pos = "inline",
    right_gravity = false,
  }
end

hipatterns.setup({
  highlighters = {
    hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
    todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
    note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
    fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },

    -- `#ffffff`
    hex_color = hipatterns.gen_highlighter.hex_color({ style = "inline", inline_text = "󱓻 " }),
    -- `#fff`
    hex_color_short = { pattern = "#%x%x%x%f[%X]", group = hex_color_short, extmark_opts = extmark_opts_inline },
    -- `rgb(255, 255, 255)`
    rgb_color = { pattern = "rgb%(%d+, ?%d+, ?%d+%)", group = rgb_color, extmark_opts = extmark_opts_inline },
    -- `rgba(255, 255, 255, 1)`
    rgba_color = {
      pattern = "rgba%(%d+, ?%d+, ?%d+, ?%d*%.?%d*%)",
      group = rgba_color,
      extmark_opts = extmark_opts_inline,
    },
  },
})

-- mini.cursorword
require("mini.cursorword").setup()

-- mini.indentscope
require("mini.indentscope").setup({
  symbol = "│",

  options = {
    try_as_border = true,
  },
})
