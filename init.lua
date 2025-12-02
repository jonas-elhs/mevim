if vim.env.PROF then
  require("snacks.profiler").startup({
    startup = {
      event = "UIEnter",
    },
  })
end

require("jonas")
