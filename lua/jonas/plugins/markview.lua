require("markview").setup({
  markdown = {
    code_blocks = {
      label_hl = "MarkviewCode",
    },

    headings = {
      heading_1 = {
        style = "label",

        align = "center",
        corner_left = "────────────────── ",
        corner_right = " ──────────────────",

        sign = "󰎥 ",
        sign_hl = "MarkviewHeading1Sign",
        icon = "",
      },
      heading_2 = {
        style = "label",

        align = "center",
        corner_left = "─────────────── ",
        corner_right = " ───────────────",

        sign = "󰎨 ",
        sign_hl = "MarkviewHeading2Sign",
        icon = "",
      },
      heading_3 = {
        style = "label",

        align = "center",
        corner_left = "──────────── ",
        corner_right = " ────────────",

        sign = "󰎫 ",
        sign_hl = "MarkviewHeading3Sign",
        icon = "",
      },
      heading_4 = {
        style = "label",

        align = "center",
        corner_left = "───────── ",
        corner_right = " ─────────",

        sign = "󰎲 ",
        sign_hl = "MarkviewHeading4Sign",
        icon = "",
      },
      heading_5 = {
        style = "label",

        align = "center",
        corner_left = "────── ",
        corner_right = " ──────",

        sign = "󰎯 ",
        sign_hl = "MarkviewHeading5Sign",
        icon = "",
      },
      heading_6 = {
        style = "label",

        align = "center",
        corner_left = "─── ",
        corner_right = " ───",

        sign = "󰎴 ",
        sign_hl = "MarkviewHeading6Sign",
        icon = "",
      },
    },

    list_items = {
      shift_width = 2,

      marker_minus = {
        text = "",
      },
    },

    tables = {
      use_virt_lines = true,
      parts = {
        align_center = { "╼", "╾" },
      },
    },
  },

  preview = {
    icon_provider = "mini",
    hybrid_modes = { "n" },
  },
})

vim.keymap.set("n", "<leader>tp", "<CMD>Markview splitToggle<CR>", { desc = "Toggle split markdown preview" })
