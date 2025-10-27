local M = {}

function M.map(modes, lhs, rhs, description, options)
  local default_options = {
    noremap = true,
    silent = true,
    desc = description or ""
  }

  vim.keymap.set(
    modes,
    lhs,
    rhs,
    vim.tbl_extend("keep", opts or {}, default_options)
  )
end

return M
