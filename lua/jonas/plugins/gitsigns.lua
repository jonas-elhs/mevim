require("gitsigns").setup({
  signcolumn = false,
  numhl = true,

  on_attach = function(buffer)
    local gitsigns = require("gitsigns")

    local function map(mode, l, r, desc)
      vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc, silent = true })
    end

    -- Navigation
    map("n", "]c", function()
      if vim.wo.diff then
        vim.cmd.normal({ "]c", bang = true })
      else
        gitsigns.nav_hunk("next")
      end
    end)
    map("n", "[c", function()
      if vim.wo.diff then
        vim.cmd.normal({ "[c", bang = true })
      else
        gitsigns.nav_hunk("prev")
      end
    end)

    -- Actions
    map("n", "<leader>hs", gitsigns.stage_hunk, "Stage hunk")
    map("n", "<leader>hr", gitsigns.reset_hunk, "Reset hunk")

    map("v", "<leader>hs", function()
      gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end, "Stage selected hunks")
    map("v", "<leader>hr", function()
      gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end, "Reset selected hunks")

    map("n", "<leader>hS", gitsigns.stage_buffer, "Stage buffer")
    map("n", "<leader>hR", gitsigns.reset_buffer, "Reset buffer")

    map("n", "<leader>hp", gitsigns.preview_hunk, "Preview hunk")
  end,
})
