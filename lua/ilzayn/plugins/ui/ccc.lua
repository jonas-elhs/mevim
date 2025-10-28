return {
  {
    "ccc.nvim",

    event = "DeferredUIEnter",

    after = function()
      local ccc = require("ccc")
      local mapping = ccc.mapping

      ccc.setup({
        highlighter = {
          auto_enable = true,
        },
        mappings = {
          ["<CR>"] = mapping.complete,
          ["q"] = mapping.quit,

          ["l"] = mapping.increase1,
          ["L"] = mapping.increase10,
          ["h"] = mapping.decrease1,
          ["H"] = mapping.decrease10,

          ["0"] = mapping.set0,
          ["M"] = mapping.set50,
          ["$"] = mapping.set100,
        },
      })
    end,
  },
}
