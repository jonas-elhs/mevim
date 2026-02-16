-- LSP Setup
local servers = {
  ty = {},
  html = {},
  tsgo = {},
  tombi = {},
  cssls = {},
  qmlls = {},
  bashls = {},
  hyprls = {},
  yamlls = {},
  jsonls = {},
  eslint = {},
  clangd = {},
  svelte = {},
  emmylua_ls = {}, -- TODO: disable keywordCompletions
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

-- Pseude Autocomplete (continue completing after word)
function disable_pseude_autocomplete()
  if vim.g.insert_completing and not vim.g.auto_completing then
    vim.o.autocomplete = false
  end

  vim.g.insert_completing = false
end

vim.api.nvim_create_autocmd({ "InsertLeave" }, {
  callback = function()
    disable_pseude_autocomplete()
  end,
})

vim.keymap.set("i", "<C-Space>", function()
  vim.o.autocomplete = true
  vim.g.insert_completing = true

  vim.lsp.completion.get()
end)
vim.keymap.set("i", "<CR>", function()
  disable_pseude_autocomplete()

  return vim.fn.pumvisible() == 1 and "<C-Y>" or "<CR>"
end, { expr = true })
vim.keymap.set("i", "<Space>", function()
  disable_pseude_autocomplete()

  return "<Space>"
end, { expr = true })

Utils.toggle({
  name = "Auto Complete",
  command = "Autocomplete",
  keymap = "<leader>ta",

  toggle = function()
    vim.o.autocomplete = not vim.o.autocomplete
    vim.g.auto_completing = not vim.g.auto_completing
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
vim.lsp.inlay_hint.enable()

-- Linked Editing Range
vim.lsp.linked_editing_range.enable()

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
