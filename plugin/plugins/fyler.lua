require("fyler").setup({
  integrations = {
    winpick = {
      provider = "snacks",
    },
  },
  views = {
    finder = {
      columns_order = {},
      confirm_simple = true,
      watcher = {
        enabled = true,
      },
      icon = {
        directory_expanded = "󰉖",
      },
      win = {
        kind = "split_right_most",
        kinds = {
          split_right_most = {
            width = "25%",
          },
        },
      },
      mappings = {
        ["<S-l>"] = "Select",
        ["<S-h>"] = function(self)
          local current_node = self:cursor_node_entry()
          local parent_ref_id = self.files:find_parent(current_node.ref_id)
          if not parent_ref_id then
            return
          end

          self:action_call("n_collapse_node")
          -- Goto parent only if in root and current_node is collapsed
          if self.files.trie.value == parent_ref_id and current_node.open == false then
            self:action_call("n_goto_parent")
          end
        end,
      },
    },
  },
})

vim.keymap.set("n", "<leader><leader>", function()
  require("fyler").toggle()
end)
