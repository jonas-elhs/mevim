require("conform").setup({
  formatters_by_ft = {
    sh = { "shfmt" },
    lua = { "stylua" },
    nix = { "alejandra" },
    qml = { "qmlformat" },
    rust = { "rustfmt" },
    toml = { "tombi" },
    python = { "ruff_organize_imports", "ruff_format" },

    c = { "clang-format" },
    cpp = { "clang-format" },

    vue = { "biome-organize-imports", "biome" },
    css = { "biome" },
    html = { "biome" },
    json = { "biome" },
    -- scss = { "biome" },
    -- yaml = { "biome" },
    jsonc = { "biome-organize-imports", "biome" },
    svelte = { "biome-organize-imports", "biome" },
    javascript = { "biome-organize-imports", "biome" },
    typescript = { "biome-organize-imports", "biome" },
    javascriptreact = { "biome-organize-imports", "biome" },
    typescriptreact = { "biome-organize-imports", "biome" },
  },

  format_on_save = function()
    return not vim.g.disable_autoformat and { timeout_ms = 1000 }
  end,
})

vim.keymap.set({ "n", "x" }, "<leader>lf", function()
  require("conform").format()
end, { desc = "Format" })

Utils.toggle({
  name = "Auto Format",
  command = "Format",
  keymap = "<leader>tf",

  toggle = function()
    vim.g.disable_autoformat = not vim.g.disable_autoformat
  end,
  enabled = function()
    return not vim.g.disable_autoformat
  end,
})
