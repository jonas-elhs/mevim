local servers = {
  ruff = {},
  html = {},
  ts_ls = {},
  cssls = {},
  svelte = {},
  bashls = {},
  eslint = {},
  clangd = {},
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
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}

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
