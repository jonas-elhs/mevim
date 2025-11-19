vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    local started = pcall(vim.treesitter.start)

    if not started then
      return
    end

    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})
