local M = {}

function M.less_than(target)
  return vim.o.columns <= target
end

function M.more_than(target)
  return vim.o.columns > target
end

return M
