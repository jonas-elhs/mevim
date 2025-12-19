require("lint").linters_by_ft = {
  sh = { "shellcheck", "bash" },
  lua = { "selene" },
  nix = { "nix" },
  rust = { "clippy" },
  python = { "ruff" },

  c = { "cppcheck" },
  cpp = { "cppcheck" },

  css = { "stylelint" },
  scss = { "stylelint" },

  html = { "eslint_d" }, -- https://github.com/BenoitZugmeyer/eslint-plugin-html
  yaml = { "eslint_d" }, -- https://github.com/ota-meshi/eslint-plugin-yml
  json = { "eslint_d" }, -- https://github.com/eslint/json
  javascript = { "eslint_d" },
  typescript = { "eslint_d" },
  svelte = { "eslint_d" }, -- https://github.com/sveltejs/eslint-plugin-svelte
}

vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave", "TextChanged" }, {
  group = vim.api.nvim_create_augroup("JonasLint", {}),
  callback = function()
    require("lint").try_lint()
  end,
})
