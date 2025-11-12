return {
  {
    "mini.surround",

    event = { "BufReadPre", "BufNewFile" },

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
  {
    "mini.icons",

    on_require = "mini.icons",

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
}
