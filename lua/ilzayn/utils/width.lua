local M = {}

function M.less_than(target)
  return vim.opt.columns._value <= target
end

function M.more_than(target)
  return vim.opt.columns._value > target
end

return M
