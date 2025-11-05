local servers = {
  ruff = {},
  html = {},
  ts_ls = {},
  cssls = {},
  bashls = {},
  hyprls = {},
  eslint = {},
  clangd = {},
  svelte = {},
  tailwindcss = {},
  rust_analyzer = {},
  emmet_language_server = {},

  nixd = {
    settings = {
      nixd = {
        nixpkgs = {
          expr = [[import (builtins.getFlake "]] .. nixCats.extra("nixdExtras.nixpkgs") .. [[") { }]],
        },
      },
    },
  },

  lua_ls = {
    settings = {
      Lua = {
        runtime = { version = "LuaJIT" },
        format = { enable = true },
        diagnostics = {
          globals = { "vim", "Snacks", "nixCats", },
        },
      },
    },
  },

  yamlls = {
    settings = {
      yaml = {
        schemaStore = {
          enabled = false,
        },
        schemas = require("schemastore").yaml.schemas(),
      },
    },
  },

  jsonls = {
    settings = {
      json = {
        schemas = require("schemastore").json.schemas(),
        validate = true,
      },
    },
  },

  pyright = {
    settings = {
      pyright = {
        disableOrganizeImports = true,
      },
      python = {
        analysis = {
          ignore = { "*" },
        },
      },
    },
  },
}

-- Capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities())

vim.lsp.config("*", {
  capabilities = capabilities,
})

-- LSP Setup
for server, config in pairs(servers) do
  if config ~= {} then
    vim.lsp.config(server, config)
  end

  vim.lsp.enable(server)
end

-- Diagnostics
vim.diagnostic.config({
  severity_sort = true,

  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.HINT] = "",
      [vim.diagnostic.severity.INFO] = "",
    },
  },

  virtual_text = {
    spacing = 2,
    source = "if_many",
    prefix = "●",
  },
})

local virtual_lines_config = {
  current_line = true,
  format = function(diagnostic)
    return diagnostic.message
  end,
}

require("ilzayn.utils").keymap.map("n", "<leader>d", function()
  local config = vim.diagnostic.config()

  if type(config.virtual_lines) == "table" and config.virtual_lines.current_line == true then
    config.virtual_lines = false
    config.virtual_text.current_line = nil
  else
    config.virtual_lines = virtual_lines_config
    config.virtual_text.current_line = false
  end

  vim.diagnostic.config(config)
end, "Toggle diagnostic lines")

-- Disable Document Colors
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function()
    vim.lsp.document_color.enable(false)
  end
})

-- Inlay Hints
vim.lsp.inlay_hint.enable(true)

-- Folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.lsp.foldexpr()"
vim.opt.foldtext = ""
vim.opt.foldlevelstart = 99
