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
  tailwindcss = {},
  rust_analyzer = {},
  emmet_language_server = {},

  nixd = {
    settings = {
      nixd = {
        nixpkgs = {
          expr = nix.info.nixd.nixpkgs,
        },
      },
    },
  },

  emmylua_ls = { -- TODO: disable keywordCompletions
    on_init = function(client)
      if client.workspace_folders then
        local path = client.workspace_folders[1].name

        if
          path ~= nix.info.config.path
          and (
            vim.uv.fs_stat(path .. "/.luarc.json")
            or vim.uv.fs_stat(path .. "/.luarc.jsonc")
            or vim.uv.fs_stat(path .. "/.emmyrc.json")
            or vim.uv.fs_stat(path .. "/.emmyrc.lua")
          )
        then
          return
        end
      end

      client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
        runtime = {
          version = "LuaJIT",
          requirePath = { "lua/?.lua", "lua/?/init.lua" },
        },
        diagnostics = {
          globals = { "Utils", "MiniIcons", "MiniFiles" },
        },
        workspace = {
          library = vim.api.nvim_get_runtime_file("", true),
          -- library = vim.tbl_filter(function(path)
          --   return not path:match(vim.fn.stdpath("config") .. "/?a?f?t?e?r?")
          -- end, vim.api.nvim_get_runtime_file("", true)),
        },
      })
    end,
    settings = {
      Lua = {},
    },
  },

  filepaths_ls = {
    settings = {
      insert_dir_trailing_slash = true,
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
vim.o.completeopt = "fuzzy,menuone,popup,noinsert,noselect"

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
vim.lsp.document_color.enable(false)

-- Inlay Hints
vim.lsp.inlay_hint.enable()

-- Linked Editing Range
vim.lsp.linked_editing_range.enable()
