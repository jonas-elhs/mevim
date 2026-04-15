require("lint").linters_by_ft = {
  sh = { "shellcheck", "bash" },
  lua = { "selene" },
  nix = { "nix", "statix" },
  rust = { "clippy" },
  python = { "ruff" },

  c = { "cppcheck" },
  cpp = { "cppcheck" },

  scss = { "stylelint" },

  vue = { "biomejs" },
  css = { "biomejs" },
  html = { "biomejs" }, -- NOTE: disabled by default as it is still experimental
  -- yaml = { "biomejs" },
  json = { "biomejs" },
  jsonc = { "biomejs" },
  svelte = { "biomejs" },
  javascript = { "biomejs" },
  typescript = { "biomejs" },
  javascriptreact = { "biomejs" },
  typescriptreact = { "biomejs" },
}

vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave", "TextChanged" }, {
  group = vim.api.nvim_create_augroup("JonasLint", {}),
  callback = function()
    require("lint").try_lint()
  end,
})
