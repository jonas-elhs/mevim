-- LSP Setup
local servers = {
  html = {},
  ts_ls = {},
  cssls = {},
  qmlls = {},
  bashls = {},
  hyprls = {},
  yamlls = {},
  jsonls = {},
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
        completion = {
          keywordSnippet = "Disable",
        },
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

for server, config in pairs(servers) do
  vim.lsp.config(server, config)
  vim.lsp.enable(server)
end

-- Completion
vim.o.complete = "o"
vim.o.pumheight = 8
vim.o.pumborder = "rounded"
vim.o.completeopt = "fuzzy,menuone,noinsert,popup"

vim.keymap.set("i", "<C-Space>", function()
  vim.lsp.completion.get()
end)

-- either accept completion or trigger blink.pairs enter mapping
require("blink.pairs.mappings").enable()
vim.keymap.set("i", "<CR>", function()
  if vim.fn.pumvisible() == 1 then
    return "<C-Y>"
  else
    local rule_lib = require("blink.pairs.rule")
    return require("blink.pairs.mappings").enter(
      rule_lib.get_all(rule_lib.parse(require("blink.pairs.config").mappings.pairs))
    )()
  end
end, { expr = true })

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    vim.lsp.completion.enable(true, event.data.client_id, event.buf, {
      convert = function(item)
        return {
          abbr = MiniIcons.get("lsp", vim.lsp.protocol.CompletionItemKind[item.kind]) .. " " .. item.label,
        }
      end,
    })
  end,
})

Utils.toggle({
  name = "Auto Complete",
  command = "Autocomplete",
  keymap = "<leader>ta",

  toggle = function()
    vim.o.autocomplete = not vim.o.autocomplete
  end,
  enabled = function()
    return vim.o.autocomplete
  end,
})

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
    prefix = "",
  },
})

local virtual_lines_config = {
  current_line = true,
  format = function(diagnostic)
    return diagnostic.message
  end,
}

Utils.toggle({
  name = "Detailed Diagnostics",
  command = "DetailedDiagnostics",
  keymap = "<leader>td",

  toggle = function(enabled)
    local config = vim.diagnostic.config() or {}

    if enabled then
      config.virtual_lines = false
      config.virtual_text.current_line = nil
    else
      config.virtual_lines = virtual_lines_config
      config.virtual_text.current_line = false
    end

    vim.diagnostic.config(config)
  end,
  enabled = function()
    local config = vim.diagnostic.config() or {}

    return type(config.virtual_lines) == "table" and config.virtual_lines.current_line == true
  end,
})
Utils.toggle({
  name = "Diagnostics",
  command = "Diagnostics",
  keymap = "<leader>tD",

  toggle = function(enabled)
    vim.diagnostic.enable(not enabled)
  end,
  enabled = function()
    return vim.diagnostic.is_enabled()
  end,
})

-- Folding
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

    if client:supports_method("textDocument/foldingRange") then
      vim.wo.foldexpr = "v:lua.vim.lsp.foldexpr()"
    else
      vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    end
  end,
})

-- Disable Document Colors
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function()
    vim.lsp.document_color.enable(false)
  end,
})

-- Inlay Hints
vim.lsp.inlay_hint.enable(true)

-- Path Completion
vim.lsp.config("path-completion-ls", {
  cmd = function(dispatchers)
    local closing = false

    return {
      request = function(method, params, callback)
        if method == vim.lsp.protocol.Methods.initialize then
          callback(nil, {
            capabilities = {
              completionProvider = {},
            },
            serverInfo = {
              name = "path-completion-ls",
              version = "1.0.0",
            },
          })
        elseif method == vim.lsp.protocol.Methods.textDocument_completion then
          local candidates = {}

          local line_to_cursor = vim.api.nvim_get_current_line():sub(1, params.position.charachter)
          local word_to_cursor = line_to_cursor:match("(%S+)$") or ""
          local match = word_to_cursor:match("^([~%.]?[%.]?/[%w_%-/%.]*)$")

          if match ~= nil then
            local path = vim.fs.normalize(match)

            if not vim.uv.fs_stat(path) then
              path = vim.fs.dirname(path)
            end

            if vim.uv.fs_stat(path) then
              for name, type in vim.fs.dir(path) do
                candidates[#candidates + 1] = {
                  label = name,
                  kind = type == "file" and vim.lsp.protocol.CompletionItemKind["File"]
                    or vim.lsp.protocol.CompletionItemKind["Folder"],
                }
              end
            end
          end

          callback(nil, {
            items = candidates,
            isIncomplete = #candidates > 0,
          })
        end
      end,
      notify = function(method)
        if method == "exit" then
          dispatchers.on_exit(0, 15)
        end
      end,
      is_closing = function()
        return closing
      end,
      terminate = function()
        closing = true
      end,
    }
  end,
})
vim.lsp.enable("path-completion-ls")
