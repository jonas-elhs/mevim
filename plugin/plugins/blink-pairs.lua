require("blink.pairs").setup({
  highlights = {
    matchparen = {
      include_surrounding = true,
    },
  },
})

-- Restore completion keymaps with blink.pairs backup
local rule_lib = require("blink.pairs.rule")
vim.keymap.set("i", "<CR>", function()
  Utils.disable_semi_autocomplete()

  if vim.fn.pumvisible() == 1 then
    -- Accept selected completion item
    return "<C-y>"
  else
    -- blink.pairs mapping
    local rule_definitions = require("blink.pairs.config").mappings.pairs
    local rules_by_key = rule_lib.parse(rule_definitions)
    local all_rules = rule_lib.get_all(rules_by_key)

    return require("blink.pairs.mappings.ops").enter(all_rules)()
  end
end, { expr = true })
